from pathlib import Path
from subprocess import Popen, check_call, check_output, Popen, PIPE, STDOUT
from pkg_resources import resource_filename

SERVER = 'ajones@aj-server.local'
REPO = 'localhost:32000'  # see https://microk8s.io/docs/working

def build():
    dirpath = '.'
    tag = 'cuda-gdb-bug:latest'
    with Popen(f'''docker -H ssh://{SERVER} build {dirpath} -t {REPO}/{tag}''', shell=True, stdout=PIPE, stderr=STDOUT) as p:
        for line in p.stdout:
            print(line.decode())
    with Popen(f'''docker -H ssh://{SERVER} push {REPO}/{tag}''', shell=True, stdout=PIPE, stderr=STDOUT) as p:
        for line in p.stdout:
            print(line.decode())

def authorize():
    print('Overwriting ~/.kube/config with new credentials')
    config = check_output(f'''ssh {SERVER} "/snap/bin/microk8s.config" ''', shell=True)
    Path('~/.kube/config').expanduser().write_bytes(config)

def stop():
    authorize()

    check_call(f'''kubectl delete deployment driver''', shell=True)
    check_call(f'''kubectl wait --for=delete deployment/driver''', shell=True)
