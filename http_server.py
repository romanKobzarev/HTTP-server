from http.server import HTTPServer, BaseHTTPRequestHandler
import re

TYPE = "IMSI"


def check_header(value):
    print('checking checking')
    if value is None:
        raise Exception('No such header')
    if len(value) not in range(1, 16):
        raise Exception('Invalid length')
    if not re.match("^[a-zA-Z0-9_]*$", value):
        raise Exception('Header includes invalid symbols')


class Serv(BaseHTTPRequestHandler):
    def do_GET(self):
        req_headers = self.headers
        print(req_headers)

        try:
            imsi_header = self.headers.get(TYPE)
            check_header(imsi_header)
            msg = 'Header is correct!'
            self.send_response(200)
        except Exception as e:
            print(e)
            msg = 'Invalid header !\n' + str(e)
            self.send_response(500)

        self.end_headers()
        self.wfile.write(bytes(msg, 'utf-8'))


httpd = HTTPServer(('localhost', 8585), Serv)
httpd.serve_forever()
