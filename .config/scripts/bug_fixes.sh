# nlantau, 2021-03-25
# Services to check when wlp2s0 won't go UP

# Check during connection phase
journalctl -fxe

# Check if multiple instances of wpa_supplicants is running
sudo ps -ef | grep wpa_supplicant

# Check journal output
journalctl -eu wpa_supplicant
