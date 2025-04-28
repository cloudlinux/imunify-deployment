# Additional packages to remove
{% set additional_packages_to_remove = [
    "cloudlinux-backup-utils",
    "imunify360-ossec",
    "imunify360-pam",
    "imunify360-php-i360",
    "imunify360-webshield-bundle",
    "imunify360-unified-access-logger",
    "imunify-ui",
    "imunify-ui-firewall-cpanel",
    "imunify-ui-firewall-plesk"
] %}

# Handle uninstall if needed
uninstall_imunify360:
  pkg.removed:
    - name: imunify360-firewall


# Cleanup old packages if needed
cleanup_old_packages:
  pkg.removed:
    - pkgs: {{ additional_packages_to_remove }}
    - require:
      - uninstall_imunify360

# Remove Plesk extension if it exists
remove_plesk_extension:
  cmd.run:
    - name: /usr/local/psa/bin/extension --uninstall imunify360
    - onlyif: test -x /usr/local/psa/bin/extension
    - require:
      - pkg: uninstall_imunify360
