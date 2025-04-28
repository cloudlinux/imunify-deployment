ensure_mod_security2_installed:
  pkg.installed:
    - name: ea-apache24-mod_security2
    - version: latest

install_imunify360:
  pkg.installed:
    - name: imunify360-firewall-cpanel
    - version: latest
    - require:
      - pkg: ensure_mod_security2_installed

install_ui_cpanel_package:
  pkg.installed:
    - name: imunify-ui-firewall-cpanel

# Register product (if activation key provided)
register_product:
  cmd.run:
    - name: imunify360-agent register {{ pillar.get('activation_key', 'IPL') }}
    - require:
      - pkg: install_imunify360