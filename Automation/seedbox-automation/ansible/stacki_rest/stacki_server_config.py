#!/opt/stack/bin/python

import os
import sys
import requests

import json
# from stack.bool import str2bool

import httplib
import logging

import getopt

if os.environ.has_key('STACKDEBUG'):
  httplib.HTTPConnection.debuglevel = 1

  logging.basicConfig(level=logging.DEBUG)
  requests_log = logging.getLogger("requests.packages.urllib3")
  requests_log.setLevel(logging.DEBUG)
  requests_log.propagate = True

class StackWSClient:
  def __init__(self, hostname, username, key):
    self.hostname = hostname
    self.username = username
    self.key      = key
    self.url      = "%s/stack" % self.hostname
    self.session  = None
    self.logged_in= False

  def login(self):
    if not self.logged_in:
      self.session = requests.Session()
      resp = self.session.get(self.url)

      csrftoken = resp.cookies['csrftoken']
      self.session.headers.update({
        "csrftoken":csrftoken, 
        "X-CSRFToken":csrftoken,
        })
      resp = self.session.post("%s/login" % self.url,
        data = {"USERNAME":self.username,"PASSWORD":self.key})
      if resp.status_code != 200:
        resp.raise_for_status()
        self.logged_in = False
      self.csrftoken = resp.cookies['csrftoken']
      self.sessionid = resp.cookies['sessionid']

      self.session.headers.update({
        "csrftoken": self.csrftoken,
        "X-CSRFToken":self.csrftoken,
        "sessionid":self.sessionid,
        })
      self.logged_in = True

  def run(self, cmd):
    if not self.logged_in:
      self.login()
    if cmd.startswith('load ') or \
      cmd.startswith('unload '):
      new_cmd = self.loadFile(cmd)
      cmd = new_cmd

    self.session.headers.update({"Content-Type": "application/json"})
    js = json.dumps({"cmd":cmd})
    resp = self.session.post(self.url, data = js)
    try:
      out = json.loads(resp.json())
      return json.dumps(out)
    except:
      out = resp.text
      return out

  def loadFile(self, cmd):
    c = cmd.split()
    filename = None
    new_cmd = []
    while c:
      arg = c.pop(0)
      if arg.startswith("file="):
        filename = arg.split('=')[1]
      else:
        new_cmd.append(arg)

    if not filename:
      raise RuntimeError("File argument not specified")
    new_filename = self.upload(filename)
    new_cmd.append("file=%s" % new_filename)
    cmd = ' '.join(new_cmd)
    return cmd

  def upload(self, filename):
    if not os.path.exists(filename) or not os.path.isfile(filename):
      raise IOError("File %s does not exist" % filename)
    basename = os.path.basename(filename)
    f = { "csvFile": (basename, open(filename, 'rb'), 'text/csv')}
    upload_url = "%s/upload/" % self.url
    resp = self.session.post(upload_url, files = f)
    out = resp.json()
    if out:
      return out['dir']


def main(argv):
  username = ""
  key = ""
  apiendpoint = ""
  cmd = ""
  try:
    opts, args = getopt.getopt(argv,"hu:k:a:c:",["user=","key=","apiendpoint=","cmd="])
  except getopt.GetoptError:
    print 'stacki_rest.py -u <user> -k <key> -a <api_endpoint> -c cmd'
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
      print 'stacki_rest.py -u <user> -k <key> -a <api_endpoint> -c cmd'
      sys.exit()
    elif opt in ("-u", "--user"):
      username = arg
    elif opt in ("-k", "--key"):
      key = arg
    elif opt in ("-a", "--apiendpoint"):
      apiendpoint = arg
    elif opt in ("-c", "--cmd"):
      cmd = arg



  stacki_cli = StackWSClient(apiendpoint, username, key)

  stacki_cli.login()

  resp = stacki_cli.run(cmd)

  print resp


if __name__ == "__main__":
  main(sys.argv[1:])


