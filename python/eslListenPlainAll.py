import ESL
import json

print(f'Listen Event Socket. plain all')

con = ESL.ESLconnection("172.43.0.10", "8021", "ClueCon")

# Test if the connection object is connected. Returns 1 if connected, 0 otherwise
res = con.connected()
if res:
    print(f'connect: ok')
    print(f'socketDescriptor: {con.socketDescriptor()}')
    con.events('plain', 'all')
    while 1:
        e = con.recvEvent()
        if e:
            try:
                event_json = e.serialize("json")
                event_dict = json.loads(event_json)
                print(f'getType {e.getType()}')
                print('='*100)
                print(event_json)
            except Exception as e:
                print(f'except: {e}')

# 'addBody'
# 'addHeader'
# 'delHeader'
# 'firstHeader'
# 'getBody'
# 'getHeader'
# 'getType'
# 'nextHeader'
# 'pushHeader'
# 'serialize'
# 'setPriority'
# 'unshiftHeader'
