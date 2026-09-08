# Lab Network Topology & Configuration

## 1. Overview
This laboratory setup consists of a primary physical host running **Linux Mint 22.3** that hosts multiple enterprise Linux virtual machines via **QEMU/KVM**, an external physical client node, a mobile peer, and an encrypted peer-to-peer overlay network powered by **Tailscale** (`100.64.0.0/10` CGNAT block).  Local LAN traffic is managed over SSH with key authentication (no passwords).

This enables the sysadmin encrypted tunnel remote access over both LAN and Internet.  When the client laptop is unavailable, status checks and minor admin tasks can be implemented through Termius/Tailscale on the mobile peer node.

---

## 2. Network Diagram

```
                       ┌─────────────────────────────────────────┐
                       │          Tailscale Mesh Overlay         │
                       │              (100.x.x.x)                │
                       └───────────────────┬─────────────────────┘
                                           │
          ┌────────────────────────────────┴────────────────────────────────┐
          │                                                                 │
  [Physical Host]                                                   [Physical Nodes]
ken-optiplex-7010                                               ken-lenovo-ideapad-110-15isk
 Linux Mint 22.3                                                     Linux Mint 22.3
 IP: 192.168.1.149 / 100.117.128.67                             IP: 192.168.1.106 / 100.109.2.114
          │                                                                 │
   (Bridge: br0)                                                        iphone-xr
          │                                                             iOS 18.7.1
   (QEMU/KVM Hypervisor)                                            IP: 100.123.193.6
          │
  ┌───────┴────────────────────────────────┐
  │ VM Infrastructure (192.168.1.0/24)     │
  ├────────────────────────────────────────┤
  │ • almalinux10  (192.168.1.131)         │
  │ • rhel-node1   (192.168.1.142)         │
  │ • the-rock     (192.168.1.109)         │
  └────────────────────────────────────────┘
```

---

## 3. Node Inventory & Specifications

### A. Physical Nodes

#### `ken-optiplex-7010` (Hypervisor & Primary Desktop)
* **OS:** Linux Mint 22.3 x86_64
* **Kernel:** `7.0.0-31-generic`
* **Hardware:** Dell OptiPlex 7010 (01)
* **CPU:** Intel® Core™ i5-3470 (4 cores) @ 3.60 GHz
* **Memory:** 15.50 GiB RAM
* **Disk:** 456.88 GiB ext4
* **Local IP:** `192.168.1.149/24` (Interface: `br0`)
* **Tailscale IP:** `100.117.128.67`

#### `ken-lenovo-ideapad-110-15isk` (Secondary Workstation)
* **OS:** Linux Mint 22.3 x86_64
* **Kernel:** `7.0.0-31-generic`
* **Hardware:** Lenovo IdeaPad 110-15ISK (80UD)
* **CPU:** Intel® Core™ i3-6100U (4 cores) @ 2.30 GHz
* **Memory:** 3.70 GiB RAM
* **Disk:** 915.32 GiB ext4
* **Local IP:** `192.168.1.106/24` (Interface: `wlp2s0`)
* **Tailscale IP:** `100.109.2.114`

---

### B. Virtual Machine Infrastructure (Hosted on `ken-optiplex-7010`)

#### `almalinux10`
* **OS:** AlmaLinux 10.2 (Lavender Lion) x86_64
* **Kernel:** `6.12.0-211.50.1.el10_2.x86_64_v2`
* **Hypervisor/Host:** Ubuntu 24.04 PC (Q35 + ICH9, 2009) (`pc-q35-noble`)
* **CPU:** Intel® Core™ i5-3470 (2 vCPUs) @ 3.19 GHz
* **Memory:** 1.66 GiB RAM
* **Disk:** 15.93 GiB xfs
* **Local IP:** `192.168.1.131/24` (Interface: `enp1s0`)
* **Tailscale IP:** `100.67.104.107`

#### `the-rock`
* **OS:** Rocky Linux 9.8 (Blue Onyx) x86_64
* **Kernel:** `5.14.0-687.44.1.el9_8.x86_64`
* **Hypervisor/Host:** Ubuntu 24.04 PC (Q35 + ICH9, 2009) (`pc-q35-noble`)
* **CPU:** Intel® Core™ i5-3470 (2 vCPUs) @ 3.19 GHz
* **Memory:** 1.67 GiB RAM
* **Disk:** 26.89 GiB root (`/`) + 1.43 GiB mount (`/mnt/reports`) xfs
* **Local IP:** `192.168.1.109/24` (Interface: `enp1s0`)
* **Tailscale IP:** `100.107.171.99`

#### `rhel-node1`
* **OS:** Red Hat Enterprise Linux 9.8 (Plow) x86_64
* **Kernel:** `5.14.0-687.5.3.el9_8.x86_64`
* **Memory:** 1.76 GiB RAM
* **Disk:** 276 GiB
* **Tailscale IP:** `100.126.26.113`

---

### C. Mobile Peers

#### `iphone-xr`
* **OS:** iOS 18.7.1
* **Tailscale Version:** `1.102.3`
* **Tailscale IP:** `100.123.193.6`

---

## 4. Networking Details

* **Local Subnet:** `192.168.1.0/24`
* **Bridge Configuration:** Primary physical interface on `ken-optiplex-7010` is bridged via `br0` to allow virtual machines direct access to the physical network interface.
* **Overlay Network:** Tailscale mesh network running version `1.102.3` across all nodes for peer-to-peer connectivity across external networks.
