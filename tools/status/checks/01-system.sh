section "System"

info "Uptime: $(uptime -p 2>/dev/null || uptime)"
info "Kernel: $(uname -srmo)"
