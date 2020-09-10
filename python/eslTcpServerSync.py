import asyncio
import os
import sys
import inspect
import base64

currentdir = os.path.dirname(os.path.abspath(
    inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0, parentdir)


PYTHON_PORT = os.getenv('PYTHON_PORT')


class TcpServerProtocol(asyncio.Protocol):
    def check_replay(self, data):
        if data == 'Content-Type: command/reply\nReply-Text: +OK\n\n':
            print(f'execute command - ok')
            self.transport.close()
            return True
        else:
            return False

    @staticmethod
    def make_dict(data):
        try:
            stream_dict = dict()
            data_list = data.split('\n')
            for l in data_list:
                k = l.split(': ')[0]
                v = l.split(': ')[1]
                stream_dict[k] = v
                print(f'{k:>40} -> {v:<40}')
        except Exception:
            pass
        if len(stream_dict) > 0:
            return stream_dict
        else:
            return False

    def connection_made(self, transport):
        peername = transport.get_extra_info('peername')
        print(f'Connection from {peername}')
        self.transport = transport
        self.transport.write('connect\n\n'.encode())
        self.stream_data = ''

    def connection_lost(self, data):
        print(f'connection lost: {self.transport.get_extra_info("peername")}')

    def eof_received(self):
        print(f'eof_received {self.transport.get_extra_info("peername")}')

    def data_received(self, data):
        try:
            self.stream_data += data.decode()
            if TcpServerProtocol.check_replay(self, self.stream_data):
                self.stream_data = ''
                return True

            if self.stream_data.endswith('\n\n'):

                stream_dict = TcpServerProtocol.make_dict(
                    self.stream_data[:-2])
                if not stream_dict:
                    return False
                self.stream_data = ''

                act = f'sendmsg {stream_dict["Unique-ID"]}\n'
                act += 'call-command: execute\n'
                act += f'execute-app-name: set\n'
                act += f'execute-app-arg: ip={self.transport.get_extra_info("peername")[0]}\n\n'
                print(f'{act}')
                self.transport.write(act.encode())

        except Exception as e:
            print(f'Error read data {e}')


async def some_job():
    while True:
        try:
            print(f'do some one')
        except Exception as e:
            pass
            # print(f'loop_queue_ws {e} ')
        finally:
            await asyncio.sleep(10)


if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    # loop.set_debug('enabled')
    server_task = loop.create_server(
        lambda: TcpServerProtocol(), '0.0.0.0', PYTHON_PORT)
    tasks = [
        loop.create_task(some_job()),
        loop.create_task(server_task),
    ]
    try:
        loop.run_until_complete(asyncio.wait(tasks))
        # loop.run_forever()
    except KeyboardInterrupt:
        print(f"\nCtrl-c quit!")
    except Exception as e:
        print(e)
    finally:
        loop.close()
        print(f"\nGoodBay!")
