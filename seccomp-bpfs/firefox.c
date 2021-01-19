
/*
 * File is generated by code generator in https://github.com/darrenldl/sandboxing
 *
 * File is based on example provided by libseccomp
 * and exportFilter.c from https://github.com/valoq/bwscripts
 */

/*
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of version 2.1 of the GNU Lesser General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses>.
 */

#include <stddef.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <seccomp.h>

int main (void) {
  int rc = -1;
  scmp_filter_ctx ctx;
  int filter_fd;

  ctx = seccomp_init(SCMP_ACT_ALLOW);
  if (ctx == NULL) { goto out; }

  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(_sysctl), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(acct), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(add_key), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(adjtimex), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(afs_syscall), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(bdflush), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(bpf), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(break), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(clock_adjtime), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(clock_settime), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(create_module), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(delete_module), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(fanotify_init), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(finit_module), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(ftime), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(get_kernel_syms), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(getpmsg), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(gtty), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(get_mempolicy), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(init_module), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(io_cancel), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(io_destroy), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(io_getevents), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(io_setup), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(io_submit), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(ioperm), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(iopl), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(ioprio_set), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(kcmp), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(kexec_file_load), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(kexec_load), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(keyctl), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(lock), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(lookup_dcookie), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(mbind), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(migrate_pages), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(modify_ldt), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(mount), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(move_pages), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(mpx), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(name_to_handle_at), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(nfsservctl), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(open_by_handle_at), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(pciconfig_iobase), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(pciconfig_read), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(pciconfig_write), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(perf_event_open), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(personality), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(pivot_root), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(process_vm_readv), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(process_vm_writev), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(prof), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(profil), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(ptrace), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(putpmsg), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(query_module), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(reboot), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(remap_file_pages), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(request_key), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(rtas), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(s390_pci_mmio_read), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(s390_pci_mmio_read), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(s390_runtime_instr), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(security), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(set_mempolicy), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(setdomainname), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(sethostname), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(settimeofday), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(sgetmask), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(ssetmask), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(stime), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(stty), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(subpage_prot), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(swapoff), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(swapon), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(switch_endian), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(sysfs), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(syslog), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(tuxcall), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(ulimit), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(umount), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(umount2), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(uselib), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(userfaultfd), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(ustat), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(vhangup), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(vm86), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(vm86old), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(vmsplice), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(vserver), 0) < 0) { goto out; }
  if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(ioctl), 1, SCMP_A1 (SCMP_CMP_MASKED_EQ, 0xFFFFFFFFu, (int) TIOCSTI)) < 0) { goto out; }

  filter_fd = open("firefox_seccomp_filter.bpf", O_CREAT | O_WRONLY | O_TRUNC, 0644);
  if (filter_fd == -1) {
    rc = -errno;
    goto out;
  }
  rc = seccomp_export_bpf(ctx, filter_fd);
  if (rc < 0) {
    close(filter_fd);
    goto out;
  }
  close(filter_fd);

out:
  seccomp_release(ctx);
  return -rc;
}
