from flask import Flask, jsonify, request
import subprocess
import re

app = Flask(__name__)

def run_script_command(command):
    """执行给定的脚本命令并返回输出或错误。"""
    try:
        output = subprocess.check_output(command, shell=True, text=True)
        clean_output = re.sub(r'\x1B[@-_][0-?]*[ -/]*[@-~]', '', output)
        return jsonify({"status": "success", "output": clean_output})
    except subprocess.CalledProcessError as e:
        return jsonify({"status": "error", "error": str(e)})

@app.route('/list_all', methods=['GET'])
def list_all():
    command = "./MTProtoProxyInstall.sh list"
    return run_script_command(command)

@app.route('/list_user', methods=['GET'])
def list_user():
    user = request.args.get('user')
    command = f"./MTProtoProxyInstall.sh list {user}"
    return run_script_command(command)

@app.route('/add_user', methods=['POST'])
def add_user():
    user = request.args.get('user')
    secret = request.args.get('secret')
    command = f"./MTProtoProxyInstall.sh 4 {user} {secret}"
    return run_script_command(command)

@app.route('/remove_user', methods=['POST'])
def remove_user():
    user = request.args.get('user')
    command = f"./MTProtoProxyInstall.sh 5 {user}"
    return run_script_command(command)

@app.route('/set_user_limit', methods=['POST'])
def set_user_limit():
    user = request.args.get('user')
    limit = request.args.get('limit')
    command = f"./MTProtoProxyInstall.sh 6 {user} {limit}"
    return run_script_command(command)

@app.route('/set_user_expiry', methods=['POST'])
def set_user_expiry():
    user = request.args.get('user')
    date = request.args.get('date')
    command = f"./MTProtoProxyInstall.sh 7 {user} {date}"
    return run_script_command(command)

if __name__ == '__main__':
    app.run(debug=True)

