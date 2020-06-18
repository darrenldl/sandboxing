type syscall =
  | Sysctl
  | Acct
  | Add_key
  | Adjtimex
  | Afs_syscall
  | Bdflush
  | Bpf
  | Break
  | Chroot
  | Clock_adjtime
  | Clock_settime
  | Create_module
  | Delete_module
  | Fanotify_init
  | Finit_module
  | Ftime
  | Get_kernel_syms
  | Getpmsg
  | Gtty
  | Get_mempolicy
  | Init_module
  | Io_cancel
  | Io_destroy
  | Io_getevents
  | Io_setup
  | Io_submit
  | Ioperm
  | Iopl
  | Ioprio_set
  | Kcmp
  | Kexec_file_load
  | Kexec_load
  | Keyctl
  | Lock
  | Lookup_dcookie
  | Mbind
  | Mfsservctl
  | Migrate_pages
  | Modify_ldt
  | Mount
  | Move_pages
  | Mpx
  | Name_to_handle_at
  | Open_by_handle_at
  | Pciconfig_iobase
  | Pciconfig_read
  | Pciconfig_write
  | Perf_event_open
  | Personality
  | Pivot_root
  | Process_vm_readv
  | Process_vm_writev
  | Prof
  | Profil
  | Ptrace
  | Putmsg
  | Query_module
  | Reboot
  | Remap_file_pages
  | Request_key
  | Rtas
  | S390_mmio_read
  | S390_mmio_write
  | S390_runtime_instr
  | Security
  | Set_mempolicy
  | Setdomainname
  | Sethostname
  | Settimeofday
  | Sgetmask
  | Ssetmask
  | Stime
  | Stty
  | Subpage_prot
  | Swapoff
  | Swapon
  | Switch_endian
  | Sysfs
  | Syslog
  | Tuxcall
  | Ulimit
  | Umount
  | Umount2
  | Uselib
  | Userfaultfd
  | Ustat
  | Vhangup
  | Vm86
  | Vm86old
  | Vmsplice
  | Vserver