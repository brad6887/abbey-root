# DNS Client Role

Configures managed Abbey lab hosts to use the authoritative internal DNS
service on `edge01`.

The role:

- Uses Technitium DNS as the primary resolver.
- Uses only resolvers authoritative for the Abbey internal namespace.
- Configures `home.arpa` as the lab search domain.
- Allows additional authoritative resolvers to be declared when available.
- Disables automatically supplied DNS servers where supported.
- Supports NetworkManager and Debian-family netplan systems.
- Prevents IPv6 router advertisements from supplying competing DNS servers and
  search domains on netplan/systemd-networkd hosts while preserving IPv6.
- Does not edit `/etc/resolv.conf` directly.

The authoritative server address is derived from the `edge01` inventory
record rather than duplicated in the role.
