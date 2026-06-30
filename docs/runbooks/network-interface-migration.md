# Network Interface Migration

This runbook documents the process of migrating an Abbey Root Linux host from Wi-Fi to a wired Ethernet connection while minimizing downtime.

---

# Purpose

Move a host from wireless networking to wired Ethernet while preserving:

- Host identity
- IP address
- Docker services
- SSH connectivity
- Ansible management

---

# Prerequisites

- USB-C Ethernet adapter or onboard Ethernet interface
- Ethernet cable connected to the network
- DHCP reservation available on the router
- Administrative access to the Linux host

---

# Procedure

## 1. Connect the Ethernet Adapter

Connect the Ethernet adapter and cable.

Verify Linux detects the interface:

bash ip -br link nmcli device status lsusb 

Expected result:

- New Ethernet interface appears (for example enx00e05c68745d)
- Adapter is detected by lsusb
- NetworkManager creates a wired connection

---

## 2. Verify Link Speed

Check negotiated link speed:

bash sudo ethtool <ethernet-interface> 

Example:

text Speed: 1000Mb/s Duplex: Full Link detected: yes 

If connected to a 2.5 Gb capable switch, the negotiated speed may be:

text 2500Mb/s 

---

## 3. Move the DHCP Reservation

If the host previously used Wi-Fi:

- Locate the DHCP reservation on the router.
- Change the reservation to the Ethernet adapter MAC address.
- Keep the same reserved IP address.

This preserves the host identity without requiring documentation or inventory updates.

---

## 4. Verify the New Address

Confirm the Ethernet interface received the expected address.

bash hostname -I ip route 

---

## 5. Test Connectivity

Verify connectivity before disabling Wi-Fi.

bash ping -c3 <gateway> ping -c3 <ansible-controller> docker ps 

---

## 6. Verify Routing

Confirm traffic to other lab systems uses the Ethernet interface.

bash ip route get <remote-host-ip> 

Expected:

text <remote-host-ip> dev <ethernet-interface> src <ethernet-ip> 

---

# Routing Issue Encountered

During the migration of ai-worker01, both Wi-Fi and Ethernet were active on the same subnet.

Although the default route correctly preferred Ethernet, Linux continued using Wi-Fi for local LAN traffic because the connected subnet route still belonged to the wireless interface.

Symptoms included:

- SSH sessions disconnected when Wi-Fi was disabled.
- ip route get showed traffic leaving via the Wi-Fi interface.

Example:

text 192.168.1.88 dev wlp0s20f3 src 192.168.1.220 

---

# Resolution

Assign the LAN route to the Ethernet connection.

Example:

bash sudo nmcli connection modify "Wired connection 2" \     connection.autoconnect-priority 100  sudo nmcli connection modify "Wired connection 2" \     ipv4.route-metric 100  sudo nmcli connection modify "Wired connection 2" \     +ipv4.routes "192.168.1.0/24 0.0.0.0 100"  sudo nmcli connection up "Wired connection 2" 

Verify:

bash ip route ip route get <remote-host-ip> 

Expected:

text 192.168.1.0/24 dev <ethernet-interface> 

and

text <remote-host-ip> dev <ethernet-interface> 

---

## 7. Disable Wi-Fi

After verifying routing, disable the wireless connection.

bash nmcli connection down "<wifi-connection>" 

Optionally prevent automatic reconnect:

bash nmcli connection modify "<wifi-connection>" connection.autoconnect no 

---

## 8. Final Verification

Confirm:

bash nmcli device status hostname -I ip route docker ps 

Expected results:

- Ethernet connected
- Wi-Fi disconnected
- Correct reserved IP address
- Docker services healthy
- SSH connectivity maintained
- Ansible connectivity verified

---

# Lessons Learned

- Preserve host identity by moving DHCP reservations rather than changing IP addresses.
- Validate routing before disabling the original interface.
- When multiple interfaces share the same subnet, verify both the default route and the connected subnet route.
- Document migration-specific issues so future migrations can follow a proven process.
