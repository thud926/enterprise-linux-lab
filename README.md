# Enterprise Linux Infrastructure & Automation Lab

A virtualized homelab environment built to simulate enterprise-grade Linux system administration, automated configuration management, and shell-based diagnostic workflows. Built on Red Hat Enterprise Linux (RHEL), Rocky Linux, and AlmaLinux, managed via KVM/QEMU virtualization on a dedicated Linux Mint hypervisor host.

---

## Architecture & Hypervisor Host Specs

                +------------------------------------+
                |  Dell OptiPlex 7010 Hypervisor     |
                |  Linux Mint 22.3 (Kernel 7.0.0)    |
                |  Intel i5-3470 | 16GB RAM | 500GB  |
                +-----------------+------------------+
                                  |
                           Bridge | (br0: 192.168.1.149/24)
                                  |
     +----------------------------+----------------------------+
     |                            |                            |
+--------v-------+           +--------v-------+           +--------v-------+
|  rhel-node1    |           |    the-rock    |           |  almalinux10   |
|  RHEL 9.8      |           |  Rocky Linux 9 |           |  AlmaLinux 10  |
|  App/Web Node  |           |  Storage Node  |           |  Testing Node  |
+----------------+           +----------------+           +----------------+


### Primary Hypervisor Node
* **Host Hardware:** Dell OptiPlex 7010 (Intel Core i5-3470 @ 3.60 GHz, 16GB RAM)
* **Host OS:** Linux Mint 22.3 x86_64 (Kernel 7.0.0-31-generic)
* **Hypervisor Stack:** KVM / QEMU managed via `libvirt`, `virsh`, and `virt-manager`
* **Network Integration:** Dedicated bridge interface (`br0` on `192.168.1.149/24`) providing direct LAN accessibility across guest nodes and remote administration endpoints.

---

## Active Cluster Inventory

| Hostname | OS / Distro | Role | Primary Interface | Storage |
| :--- | :--- | :--- | :--- | :--- |
| `ken-OptiPlex-7010` | Linux Mint 22.3 | KVM Hypervisor Host | `br0` (`192.168.1.149`) | 500GB LVM / ext4 |
| `rhel-node1` | RHEL 9.8 | Target Enterprise Node | Virtual Bridge | LVM (XFS) |
| `the-rock` | Rocky Linux 9.8 | Service & Utility Node | Virtual Bridge | LVM (XFS) |
| `almalinux10` | AlmaLinux 10 | Enterprise Preview / Test | Virtual Bridge | LVM (XFS) |

---

## Repository Structure

```text
enterprise-linux-lab/
├── README.md               # Infrastructure documentation and cluster topology
├── .gitignore              # Global repository exclusion definitions
├── ansible/                # Automation playbooks and host inventories
│   ├── inventory           # Managed node definitions
│   └── site.yml            # Primary execution playbook
├── scripts/                # Custom CLI utilities and manual pages
│   ├── bin/                # Shell helpers (yeet, yoink, kobe)
│   └── man/                # Native Unix man pages (yeet.1, yoink.1, kobe.1)
└── docs/                   # Visual assets and post-mortem logs
    └── assets/             # Terminal captures and architecture diagrams

---

## 📄 Technical Post-Mortems & Verification Logs

- **[Bunkwerks Trilogy Installation & Cross-Node Verification](docs/post-mortems/bunkwerks-verification.md)**: End-to-end testing log covering custom binary installation, manual page compilation, remote file fetching (`yoink`), SSH transport (`kobe`), and interactive target removal (`yeet`).
