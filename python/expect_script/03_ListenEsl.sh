#!/usr/bin/expect -f
# https://freeswitch.org/confluence/display/FREESWITCH/Event+List
# https://freeswitch.org/confluence/display/FREESWITCH/mod_event_socket
# https://freeswitch.org/confluence/display/FREESWITCH/Event+Socket+Library
set HOST 172.43.0.10
set PORT 8021
set PASSWORD ClueCon


log_user 1

spawn telnet $HOST $PORT
send_user "connect to ESL FreeSwitch $HOST $PORT\n\r"

expect "Content-Type: auth/request\r\n\r\n" {
            send_user "=============================== 1 ================================\n\r"
            stty -echo
            send_user "Inpue ESL password (ClueCon): "
            expect_user -timeout 3600 -re "(.*)\[\r\n]"
            stty echo
            send "auth $expect_out(1,string)\r\n\r\n"
        }

expect "Content-Type: command/reply\r\nReply-Text: \+OK accepted\r\n\r\n" {
            send_user "================================ 2 ===============================\n\r"
            send "events xml HEARTBEAT\r\n\r\n"
        }

expect "Content-Type: command/reply\r\nReply-Text: +OK event listener enabled xml\r\n\r\n" {
            send_user "================================ 3 ===============================\n\r"
            send "api sofia status profile internal reg\r\n\r\n"
        }


expect "Total items returned*\r\n*\r\n*" {
            send_user "================================ 4 ===============================\n\r"
            send "api status\r\n\r\n"
        }

expect "Current Stack*\r\n*" {
            send_user "================================ 5 ===============================\n\r"
        }

interact
exit 0









spawn telnet $HOST $PORT
send_user "connect to ESL FreeSwitch $HOST $PORT\n\r"
#stty -echo - unvisible input. (usefull for input secrets passwords)
#stty echo

expect "Content-Type: auth/request\r\n\r\n" {
            send_user "log: start auth\n\r"
            send "auth $PASSWORD\r\n\r\n"
        }

expect "Content-Type: command/reply\r\nReply-Text: \+OK accepted\r\n\r\n" {
    send_user "log: auth ok\r\n"
    
    send "events plain all\r\n\r\n"
    # send "LOG 9\r\n\r\n"
    # send "events json HEARTBEAT\r\n\r\n"
    
    }

send "sendevent ASTERCONF2020_EVENTS
city: Moscow
user: Alex
host: 1.2.3.4
device: NoDevice
Feature-Event: DoNotDisturbEvent
doNotDisturbOn: on\r\n\r\n"
# expect "Content-Type: command/reply\r\nReply-Text: \+OK accepted\r\n\r\n" {
#     send_user "log: auth ok\r\n"
    
#     # send "events json all\r\n\r\n"
#     # send "LOG 9\r\n\r\n"
#     # send "events json HEARTBEAT\r\n\r\n"
    
#     }
interact
exit 0




# proc myfunc { MY_COUNT } {
#     set MY_COUNT [expr $MY_COUNT + 1]
#     return "$MY_COUNT"
# }

set COUNT 0
while { $COUNT <= 5 } {
    send_user "input data: "
    expect_user -timeout 3600 -re "(.*)\[\r\n]"
    set REPLY "$expect_out(1,string)"
    puts "REPLY: $REPLY and COUNT is currently at $COUNT\n"
    set COUNT [expr $COUNT + 1]

  if { $REPLY == "1" } {
    puts "{\"command\":\"ussd\", \"channel\":\"$CHANNEL\", \"option\":\"*201#\", \"ussd_exit\":\"1\"}\n\r"
    send "{\"command\":\"ussd\", \"channel\":\"$CHANNEL\", \"option\":\"*201#\", \"ussd_exit\":\"1\"}\n\r"
    } else {
    puts "{\"command\":\"ussd\", \"channel\":\"$CHANNEL\", \"option\":\"\"}\n\r"
    send "{\"command\":\"ussd\", \"channel\":\"$CHANNEL\", \"option\":\"\"}\n\r"
  }
}

interact
exit 0
