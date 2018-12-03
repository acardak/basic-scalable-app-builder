import argparse
import shlex
import subprocess as sb
import uuid
from flask import Flask, request

app = Flask(__name__)


def get_input_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--port', required=True)
    return parser.parse_args()


@app.route('/')
def get_hostname():
    cmd = "cat /etc/hostname"
    args = shlex.split(cmd)
    p = sb.Popen(args, shell=False, stdout=sb.PIPE, stderr=sb.PIPE)
    stdo = p.communicate()[0]
    return stdo.decode('utf-8')


@app.route('/counter/<string:counter_id>')
def get_counter(counter_id):
    # TODO: Get counter by id and return current number
    # and number to count until as {"current": 5, "to": 100}
    counter = {"current": 'foo', "to": 'baz'}
    return str(counter)


@app.route('/counter/')
def set_new_counter_or_list_all_counters():
    count_to = request.args.get('to')
    if count_to is not None:
        # TODO: Set a new counter in a db and return its counter_id
        # when 'to' is defined
        return str(uuid.uuid4())
    else:
        # TODO: Return list of all counter_ids when 'to' is undefined
        counter_ids = [str(uuid.uuid4()), str(uuid.uuid4())]
        return str(counter_ids)


def main():
    input_args = get_input_arguments()
    resp_port = int(input_args.port)
    app.run(host='0.0.0.0', port=resp_port)


if __name__ == "__main__":
    main()
