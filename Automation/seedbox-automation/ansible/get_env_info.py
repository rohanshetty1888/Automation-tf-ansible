import http.client
import json
import os
import sys
import getpass

from urllib.parse import urlparse
from pprint import pprint

SOURCE_SYSTEM_FILE_NAME = 'system_info.json'
AGENT_CONFIG_FILE_NAME = 'agent_config.yml'

YML_DATA = ""
CONFIG = {
    "stage": "dev",
    "client_id": "h4psC1NTevUPYCJ6hTa76htrup4UNIyq",
    "client_secret": "y96yTT3jlXSPUvw7H7DHHkCVYWJTS_8AKQJcemSZ06vPdStUEe3BTKwxyIXAOvo5",
    "audience": "https://dev.api.teradatacloud.io/",
    "grant_type": "http://auth0.com/oauth/grant-type/password-realm",
    "realm": "DSS",
    "scope": "openid profile",
    "Auth0_Url": "",
    "URL": {
        "AUTH0_URL": "https://sso.teradatacloud.io/oauth/token",
        "CREATE_USER": "https://ga6x17tucc.execute-api.us-west-2.amazonaws.com/dev/auth/users",
        "ENDPOINTS_URL": "https://e39vocykp2.execute-api.us-west-2.amazonaws.com/dev/endpoints"
    }
}

AGENT_CONFIG = {
    "agent": {
        "credentials": {},
        "urls": {}
    }
}


def get_response(http_method, url, payload, headers):
    result = urlparse(url)
    base_url = result.netloc
    api_url = result.path
    query = result.query

    if query:
        api_url = "{0}?{1}".format(api_url, query)
    connection = http.client.HTTPSConnection(base_url)
    payload = payload if payload is None else json.dumps(payload)
    connection.request(http_method, api_url, payload, headers)
    res = connection.getresponse()
    data = res.read()
    # print(data)
    decoded = data.decode("utf-8")
    return decoded


def set_config():
    agent_config = AGENT_CONFIG['agent']['credentials']
    agent_config['client_id'] = CONFIG['client_id']
    agent_config['client_secret'] = CONFIG['client_secret']
    agent_config['realm'] = CONFIG['realm']
    agent_config['scope'] = CONFIG['scope']


def set_token(username, password):
    auth_payload = {
        "client_id": CONFIG['client_id'],
        "client_secret": CONFIG['client_secret'],
        "audience": CONFIG['audience'],
        "grant_type": CONFIG['grant_type'],
        "username": username,
        "password": password,
        "realm": "AD-DEV",
        "scope": CONFIG['scope'],
    }

    headers = {
        "content-type": "application/json"
    }
    auth_response = get_response("POST", CONFIG['URL']['AUTH0_URL'],
                                 auth_payload, headers)
    CONFIG['token'] = json.loads(auth_response)['access_token']


def update_agent_credentials():
    create_box_user_payload = {
        "role": "Craneagent"
    }

    headers = {
        "Authorization": "Bearer {0}".format(CONFIG['token']),
        "Content-Type": "application/json"
    }

    response = json.loads(get_response("POST", CONFIG["URL"]["CREATE_USER"],
                                       create_box_user_payload, headers))

    AGENT_CONFIG['agent']['credentials']['username'] = response['userId']
    AGENT_CONFIG['agent']['credentials']['password'] = response['password']



def update_agent_urls():
    agent_config = AGENT_CONFIG['agent']['urls']
    agent_config['GRANT_TYPE_URL'] = CONFIG['grant_type']
    agent_config['AUDIENCE_TOKEN_URL'] = CONFIG['audience']
    agent_config['AGENT_TOKEN_URL'] = urlparse(CONFIG['URL']['AUTH0_URL']).netloc

    headers = {
        "Authorization": "Bearer {0}".format(CONFIG['token']),
        "content-type": "application/json"
    }
    response = json.loads(get_response("GET", CONFIG["URL"]["ENDPOINTS_URL"],
                                       None, headers))
    job_service_base_url = __fetch_base_url(
        response['seedjob-service-'+CONFIG['stage']][0]['endpoint'])
    agent_service_base_url = __fetch_base_url(
        response['agent-service-' + CONFIG['stage']][0]['endpoint'])
    box_service_base_url = __fetch_base_url(
        response['box-manager-' + CONFIG['stage']][0]['endpoint'])

    agent_config['SEED_JOB_DETAIL_URL'] = "{0}/{1}/jobs/{{0}}".format(
        job_service_base_url, CONFIG['stage'])

    agent_config['AGENT_DETAIL_URL'] = "{0}/{1}/agents/{{0}}".format(
        agent_service_base_url, CONFIG['stage'])
    agent_config['AGENT_REGISTER_URL'] = "{0}/{1}/agents/{{0}}/register".format(
        agent_service_base_url, CONFIG['stage'])
    agent_config['GET_AGENT_TASK_URL'] = "{0}/{1}/agents/{{0}}/tasks".format(
        agent_service_base_url, CONFIG['stage'])
    agent_config['UPDATE_AGENT_TASK_URL'] = "{0}/{1}/agents/tasks/{{0}}".format(
        agent_service_base_url, CONFIG['stage'])
    agent_config['AGENT_ACTION_ON_JOB_URL'] = "{0}/{1}/jobs/agent/{{0}}?action={{1}}".format(
        agent_service_base_url, CONFIG['stage'])
    agent_config['BOX_ACTION_URL'] = "{0}/{1}/box?agent_id={{0}}&action={{1}}".format(
        box_service_base_url, CONFIG['stage'])


def get_source_system_info(job_id):
    get_job_detail_url = "{0}?fields=source_environment,agent_id".format(
        str(AGENT_CONFIG['agent']['urls']['SEED_JOB_DETAIL_URL']).format(job_id)
    )
    headers = {
        "Authorization": "Bearer {0}".format(CONFIG['token']),
        "content-type": "application/json"
    }
    response = json.loads(get_response("GET", get_job_detail_url,
                                       None, headers))
    AGENT_CONFIG['agent']['credentials']['agent_id'] = response['agent_id']
    # with open(SOURCE_SYSTEM_FILE_NAME, 'w') as fp:
    #     json.dump(response['source_environment'], fp, indent=4)

    output = open('main.yml', 'w')
    ntp_conf_file = open('ntp.conf', 'w')
    hosts_file = open('hosts', 'w')
    # FILE = "systeminfo.json"
    # with open(FILE, 'r') as myfile:
    #     data = myfile.read()
    system_info = dict(response)
    output.write("---\n")
    output.write("bynet_version: {}\n".format(
        system_info["source_environment"]["details"]["system"]["version"]["BLM driver"]))
    for node in system_info["source_environment"]["details"]["system"]["nodes"]:
        short_name = ""
        # i = 0
        for name in node["short_hostname"]:
            short_name = short_name + " " + name
            hosts_file.write("{} {} {}\n".format(
                node["ip"], node["full_qualified_hostname"], short_name))
            # i = i + 1
    ntp_config = ""
    for ntp in system_info["source_environment"]["details"]["system"]["ntp_servers"]:
        ntp_config = ntp_config + ntp
    ntp_conf_file.write(ntp_config)
    max_pma = -1
    for bynet in system_info["source_environment"]["details"]["system"]["bynet_nodes"]:
        pma = int(bynet["pmaid"])
        if pma > max_pma:
            max_pma = pma
    output.write("new_pam: {}\n".format(max_pma + 10))
    output.write("BYNET1IP: 10.16.2.239\n")
    output.write("BYNET1MASK: 255.255.0.0\n")
    hosts_file.write("127.0.0.1 localhost inf-be-dss-backend-01\n")
    hosts_file.write("192.168.122.77 dsurepo\n")
    hosts_file.write("192.168.122.177 viewpoint\n")
    hosts_file.write("10.16.131.6  TDCLOUD15TD36-3-6  CT00006Acop1\n")
    hosts_file.write("10.16.2.2    inf-nbu-mstr01-qa\n")
    output.close()
    ntp_conf_file.close()
    hosts_file.close()

    # print("Source system json file name: " + SOURCE_SYSTEM_FILE_NAME)


def convert_dict_to_yml(agent_config, space_separator):
    global YML_DATA
    if type(agent_config) != dict:
        return
    for key, value in agent_config.items():
        if key== 'urls' and type(value) == dict:
            continue
        YML_DATA = YML_DATA + space_separator + key + ":"
        if type(value) == dict:
            YML_DATA = YML_DATA + "\n"
            convert_dict_to_yml(value, space_separator + "  ")
        else:
            YML_DATA = YML_DATA + " " + value + "\n"


def __fetch_base_url(endpoint):
    value = urlparse(endpoint)
    return "{0}://{1}".format(value.scheme, value.netloc)


def start():
    if len(sys.argv) == 4:
        username = sys.argv[1]
        password = sys.argv[2]
        job_id = sys.argv[3]
    else:
        username = input('Username:')
        password = getpass.getpass('Password:')
        job_id = input('Job_id:')
    # print(username)
    # print(password)
    # print(job_id)

    # username = 'sys.ops'  # input('Username:')
    # password = 'pass@word1'  # getpass.getpass('Password:')
    # job_id = 'd27566c9-213f-4aee-8ecf-cdfb7effd79c'  # input('Job_id:')
    # # print(sys.argv)
    set_config()
    print('Configuration set.')
    set_token(username, password)
    print('Fetching urls...')
    update_agent_urls()
    print('Fetching source system info...')
    get_source_system_info(job_id)
    print('Creating box user...')
    update_agent_credentials()
    global YML_DATA
    convert_dict_to_yml(AGENT_CONFIG, "")
    with open(AGENT_CONFIG_FILE_NAME, 'w') as fp:
        fp.write(YML_DATA)
    print("Agent config file name: " + AGENT_CONFIG_FILE_NAME)
    print("Done.")
start()
