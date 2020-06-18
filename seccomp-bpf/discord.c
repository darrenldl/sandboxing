
/*
 * File is generated by bw-script-gen in https://github.com/darrenldl/sandboxing
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


  filter_fd = open("discord_seccomp_filter.bpf", O_CREAT | O_WRONLY | O_TRUNC, 0644);
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
