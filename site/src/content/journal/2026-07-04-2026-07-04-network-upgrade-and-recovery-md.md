# 2026-07-04 - Network Upgrade and Recovery

## Summary

Today's goal was to upgrade the Abbey Root lab network by installing a new 2.5 Gb switch. What began as a straightforward hardware upgrade quickly turned into an unexpected troubleshooting exercise after the Proxmox host lost network connectivity.

Although the original USB Ethernet adapter was accidentally damaged during the hardware move, the issue ultimately resulted in a successful upgrade to 2.5 Gb networking and several valuable operational lessons.

---

## Objectives

- Install new TRENDnet 8-port 2.5 Gb switch.
- Upgrade the Proxmox host to 2.5 Gb networking.
- Improve overall lab network performance.
- Continue organizing the lab infrastructure.

---

## Accomplishments

### Installed 2.5 Gb Switch

Installed the TRENDnet 8-port unmanaged 2.5 Gb switch.

Verified:

- Switch connected to the AT&T BGW320 gateway.
- Switch connected to the gateway's 5 Gb Ethernet port.
- All active devices negotiated successfully.

### Hardware Failure

While reorganizing the lab, the original USB-C Ethernet adapter used by the Proxmox host was dropped and the USB-C connector was bent.

Symptoms included:

- No network connectivity.
- No link when connected to either the new switch or the AT&T gateway.
- Proxmox host became unreachable.

Fortunately, the failure was isolated to the USB Ethernet adapter.

### Troubleshooting

Systematically verified:

- Proxmox networking configuration.
- Linux bridge configuration.
- USB Ethernet hardware.
- Intel AX201 Wi-Fi hardware.
- Wi-Fi driver and firmware.
- iPhone USB tethering.
- Physical network connectivity.
- Switch port negotiation.

Although Wi-Fi and USB tethering were investigated as temporary recovery options, neither proved to be a practical solution without additional software.

### Replacement Adapter

Purchased a replacement USB-C 2.5 Gb Ethernet adapter.

Verified:

- Linux detected the new adapter immediately.
- Successfully negotiated a 2.5 Gb full-duplex link with the TRENDnet switch.

### Network Recovery

Updated the Proxmox bridge configuration to use the new network interface.

During recovery, an incorrect interface name was entered into `/etc/network/interfaces`.

The difference was subtle:

```
Incorrect:
enxbc1ff7c0de2d

Correct:
enx6c1ff7c0de2d
```

The typo prevented the bridge from attaching to the physical interface.

After correcting the interface name:

- Bridge initialized successfully.
- Gateway connectivity restored.
- Proxmox management interface became available.
- Virtual machines regained network connectivity.

---

## Final Result

Successfully restored the lab with:

- 2.5 Gb switch installed
- 2.5 Gb Proxmox network connection
- All virtual machines operational
- Full connectivity restored

---

## Lessons Learned

### Verify the Physical Layer First

Link lights and `ethtool` quickly confirmed whether hardware was functioning correctly.

### Use `ethtool`

`ethtool` proved invaluable for confirming:

- Link status
- Negotiated speed
- Duplex
- Driver functionality

### Copy and Paste Long Identifiers

Long interface names are easy to misread.

Typing:

```
enxbc...
```

instead of:

```
enx6c...
```

cost significant troubleshooting time.

Future workflow should prefer copy/paste whenever practical.

### Small Typos Can Cause Large Problems

A single incorrect character prevented the Linux bridge from functioning correctly.

Configuration files should always be verified carefully after editing.

### Keep Spare Hardware

A spare USB Ethernet adapter would have reduced recovery time considerably.

Future lab inventory should include:

- Spare USB Ethernet adapter
- Spare Ethernet cables
- Spare power adapters where practical

---

## Ideas

Today's troubleshooting inspired several future improvements for the Abbey toolkit.

Potential `abbey doctor` network checks:

- Verify bridge interfaces exist.
- Detect missing bridge ports.
- Report negotiated link speed.
- Verify gateway connectivity.
- Verify Internet connectivity.
- Warn when configured interfaces no longer exist.

These checks could identify common configuration mistakes before they become major problems.

---

## Reflection

Although the day started as a simple hardware upgrade, it became one of the most educational troubleshooting sessions since beginning Abbey Root.

The experience reinforced an important philosophy of the project:

Build things.
Break things.
Understand why they broke.
Improve the process.
Document what was learned.

The lab ultimately emerged stronger than before, with a faster network connection, improved documentation ideas, and several enhancements planned for future automation.
