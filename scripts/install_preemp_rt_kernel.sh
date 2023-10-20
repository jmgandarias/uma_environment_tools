#bin!/bin/bash

source "`dirname \"$0\"`"/utils.sh

sudo apt-get install -y build-essential bc curl ca-certificates fakeroot gnupg2 libssl-dev lsb-release libelf-dev bison flex cpufrequtils indicator-cpufreq

# KERNEL_VERSION='4.14.12'
KERNEL_VERSION='5.2.21-rt15'

# mkdir -p ./rt_kernel_install
# cd rt_kernel_install

KV_1=`echo $KERNEL_VERSION | cut -d'.' -f 1`
KV_2=`echo $KERNEL_VERSION | cut -d'.' -f 2`
KV_3_TMP=`echo $KERNEL_VERSION | cut -d'.' -f 3`
KV_3=`echo $KV_3_TMP | cut -d'-' -f 1`
KV_RT=`echo $KERNEL_VERSION | cut -d'-' -f 2`

# Download the source files
curl -SLO https://www.kernel.org/pub/linux/kernel/v${KV_1}.x/linux-${KV_1}.${KV_2}.${KV_3}.tar.xz
curl -SLO https://www.kernel.org/pub/linux/kernel/v${KV_1}.x/linux-${KV_1}.${KV_2}.${KV_3}.tar.sign
curl -SLO https://www.kernel.org/pub/linux/kernel/projects/rt/${KV_1}.${KV_2}/older/patch-${KV_1}.${KV_2}.${KV_3}-${KV_RT}.patch.xz
curl -SLO https://www.kernel.org/pub/linux/kernel/projects/rt/${KV_1}.${KV_2}/older/patch-${KV_1}.${KV_2}.${KV_3}-${KV_RT}.patch.sign

# Decompress them
xz -d linux-${KV_1}.${KV_2}.${KV_3}.tar.xz
xz -d patch-${KV_1}.${KV_2}.${KV_3}-${KV_RT}.patch.xz

# Check the integrity
warn "Verififing integrity of: linux-${KV_1}.${KV_2}.${KV_3}.tar.sign..."
gpg2 --verify linux-${KV_1}.${KV_2}.${KV_3}.tar.sign

echo
warn "You should have received a result like this:"
echo
echo "gpg: assuming signed data in 'linux-4.14.12.tar'"
echo "gpg: Signature made Fr 05 Jan 2018 06:49:11 PST using RSA key ID 6092693E"
echo "gpg: Can't check signature: No public key"
echo
warn or:
echo
echo "gpg: assuming signed data in 'linux-4.14.12.tar'"
echo "gpg: Signature made Fr 05 Jan 2018 06:49:11 PST using RSA key 647F28654894E3BD457199BE38DBBDC86092693E"
echo "gpg: Can't check signature: No public key"

echo
warn "If the output is \"using RSA key ID <hexadecimal-code>\" or \"using RSA key <long-hexadecimal-code>\", otherwise if you received a good signature, just press enter:"
read PUBLIC_KEY

# Download the public keys if necessary
if [ "$PUBLIC_KEY" != "" ]; then
    echo "Download public key..."
    gpg2 --keyserver hkp://keys.gnupg.net --recv-keys $PUBLIC_KEY
fi

gpg2 --verify linux-${KV_1}.${KV_2}.${KV_3}.tar.sign

warn "Verififing integrity of: patch-${KV_1}.${KV_2}.${KV_3}-${KV_RT}.patch.sign..."
gpg2 --verify patch-${KV_1}.${KV_2}.${KV_3}-${KV_RT}.patch.sign

echo
warn "You should have received a result like this:"
echo
echo "gpg: assuming signed data in 'patch-4.14.12-rt33.patch'"
echo "gpg: Signature made Fr 05 Jan 2018 06:49:11 PST using RSA key ID 6092693E"
echo "gpg: Can't check signature: No public key"
echo
warn or:
echo
echo "gpg: assuming signed data in 'patch-5.4.54-rt33.patch'"
echo "gpg: Signature made Sa 15 Aug 2020 00:23:46 CEST"
echo "gpg:                using EDDSA key 514B0EDE3C387F944FB3799329E574109AEBFAAA"
echo "gpg: Can't check signature: No public key"

echo
warn "If the output is \"using RSA key ID <hexadecimal-code>\" or \"using EDDSA key <long-hexadecimal-code>\", otherwise if you received a good signature, just press enter:"
read PUBLIC_KEY

# Download the public keys if necessary
if [ "$PUBLIC_KEY" != "" ]; then
    echo "Download public key..."
    gpg2 --keyserver hkp://keys.gnupg.net --recv-keys $PUBLIC_KEY
fi
gpg2 --verify patch-${KV_1}.${KV_2}.${KV_3}-${KV_RT}.patch.sign

warn "Did you receive two messages containing \"Good signature from \"Greg Kroah-Hartman <gregkh@linuxfoundation.org>\"\"\?(Y/n)"
read YN_ANSWER

if [ "$YN_ANSWER" == "n" ]; then
    error "Error: you HAVE to receive a good signature from the verification procedure. Call Mattia or Pietro.(Sorry for the non professional message)."
fi

tar xf linux-${KV_1}.${KV_2}.${KV_3}.tar
cd linux-${KV_1}.${KV_2}.${KV_3}
patch -p1 < ../patch-${KV_1}.${KV_2}.${KV_3}-${KV_RT}.patch

warn "Choose the Fully Preemptible Kernel (RT) (PREEMPT_RT_FULL), and keep other options at their default values."
make oldconfig

fakeroot make -j4 deb-pkg
# if fakeroot return false, use the following command
# sudo make -j4 deb-pkg

sudo dpkg -i ../linux-headers-${KV_1}.${KV_2}.${KV_3}-${KV_RT}_*.deb ../linux-image-${KV_1}.${KV_2}.${KV_3}-${KV_RT}_*.deb
# sudo dpkg -i ../linux-headers-4.14.12-rt10_*.deb ../linux-image-4.14.12-rt10_*.deb

sudo addgroup realtime

sudo usermod -a -G realtime $(whoami)

echo '@realtime soft rtprio 99' | sudo tee -a /etc/security/limits.conf
echo '@realtime soft priority 99' | sudo tee -a /etc/security/limits.conf
echo '@realtime soft memlock 102400' | sudo tee -a /etc/security/limits.conf
echo '@realtime hard rtprio 99' | sudo tee -a /etc/security/limits.conf
echo '@realtime hard priority 99' | sudo tee -a /etc/security/limits.conf
echo '@rrealtime hard memlock 102400' | sudo tee -a /etc/security/limits.conf
