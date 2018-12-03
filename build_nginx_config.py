import argparse
from jinja2 import Template


def get_input_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--server-num', required=True)
    return parser.parse_args()


def main():
    input_args = get_input_arguments()
    server_num = int(input_args.server_num)
    nginx_conf = ''
    with open('custom_nginx.conf.j2') as f:
        template = Template(f.read())
        nginx_conf = template.render(server_num=range(server_num))
    with open('custom_nginx.conf', 'w') as f:
        f.write(nginx_conf)


if __name__ == "__main__":
    main()
