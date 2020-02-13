exec > /tmp/terraform_bootstrap_script.log 2>&1

function set_tmp_path() {
  if [[ ! -d ${tmp_path} ]]; then
    mkdir -p ${tmp_path}
  fi
}

%{ if set_hostname }
%{ if ip_hostname }
HNAME=${hostname}-$(hostname -I | sed 's/\./-/g')
%{ else }
HNAME=${hostname}
%{ endif }
if hash hostnamectl &>/dev/null; then
  hostnamectl set-hostname $${HNAME}
fi
%{ endif }

%{ if create_user }
if sed 's/"//g' /etc/os-release |grep -e '^NAME=CentOS' -e '^NAME=Fedora' -e '^NAME=Red'; then
  useradd ${user_name}
  usermod -a -G wheel ${user_name}
  %{ if user_pass != "" }
  echo "${user_pass}" | passwd --stdin ${user_name}
  %{ endif }
elif sed 's/"//g' /etc/os-release |grep -e '^NAME=Mint' -e '^NAME=Ubuntu' -e '^NAME=Debian'; then
  apt-get clean
  apt-get update
  useradd ${user_name} -s /bin/bash -m
  usermod -a -G sudo ${user_name}
  %{ if user_pass != "" }
  echo -e "${user_pass}\n${user_pass}" | passwd ${user_name}
  %{ endif }
elif sed 's/"//g' /etc/os-release |grep -e '^NAME=SLES'; then
  if ! grep $(hostname) /etc/hosts; then
    echo "127.0.0.1 $(hostname)" >> /etc/hosts
  fi
  %{ if user_pass != "" }
  pass=$(perl -e 'print crypt($ARGV[0], "password")' ${user_pass})
  useradd -U -m -p $pass ${user_name}
  %{ else }
  useradd -U -m ${user_name}
  %{ endif }
fi

printf >"/etc/sudoers.d/${user_name}" '%s    ALL= NOPASSWD: ALL\n' "${user_name}"

%{ if user_public_key != "" }
mkdir -p /home/${user_name}/.ssh
chmod 700  /home/${user_name}/.ssh
cat << EOF >>/home/${user_name}/.ssh/authorized_keys
${user_public_key}
EOF
chmod 600 /home/${user_name}/.ssh/authorized_keys
chown -R ${user_name}:${user_name} /home/${user_name}/.ssh
%{ else }
sed -i  's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
%{ endif }
%{ endif }


%{ if populate_hosts }
if ! grep "$(hostname -I) $(hostname)" /etc/hosts; then
  echo "$(hostname -I) $(hostname)" >> /etc/hosts
fi
%{ endif }
