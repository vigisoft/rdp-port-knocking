# RDP Port Knocking
This program implements port knocking for access to Windows via RDP.

## First steps
It is important to note that firewall settings and remote access service installation must be done in advance by a qualified professional.

## How it works
The application will listen to 3 random ports (*which you can modify later*) and allow TS / RDP access to your Windows environment. After 30 seconds access will be blocked, not affecting the current session (*if any*).

The user has 30 seconds to make the connection (using some TCP socket client - like **telnet**), in the proper sequence of ports (*1, 2 and 3*).

## ToDo
- [ ] Translate
- [x] Automatically block TS / RDP access after 30 seconds of an accepted connection
- [ ] Enable dynamic RDP port switching on each connection and advise the client on which port RDP access is available
- [ ] Adjust firewall according to selected RDP port
- [ ] Enable the Remote Desktop service automatically if it is disabled
