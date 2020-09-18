#!/usr/bin/expect -f

set HOST 172.43.0.10
set PORT 8021
set PASSWORD ClueCon

log_user 1

spawn telnet $HOST $PORT
send_user "connect to ESL FreeSwitch $HOST $PORT\n\r"

expect "Content-Type: auth/request\r\n\r\n" {
            send_user "=============================== 1 ================================\n\r"
            send "auth $PASSWORD\r\n\r\n"
        }

expect "Content-Type: command/reply\r\nReply-Text: \+OK accepted\r\n\r\n" {
            send_user "================================ 2 ===============================\n\r"
            send "events plain all\r\n\r\n"
        }

expect "Content-Type: command/reply\r\nReply-Text: +OK event listener enabled plain\r\n\r\n" {
            send_user "================================ 3 ===============================\n\r"
            send "sendevent ASTERCONF2020_EVENTS
aster-city: Moscow
aster-user: Alex
aster-host: 1.2.3.4
aster-device: NoDevice
aster-Feature-Event: DoNotDisturbEvent
aster-pramp-pam-pam: on\r\n\r\n"
        }


expect "Content-Type: command/reply\r\nReply-Text: +OK*\r\n\r\n" {
            send_user "================================ 4 ===============================\n\r"
        }

interact
exit 0


