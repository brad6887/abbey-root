# Abbey Root shell initialization

abbey_toolkit_root="$HOME/git/abbey-root"

if [ -d "$abbey_toolkit_root" ]; then
  # Add both the legacy tool directory and the registered CLI dispatcher.
  # The loop order leaves tools/bin first in the effective PATH.
  for abbey_path in \
    "$abbey_toolkit_root/tools" \
    "$abbey_toolkit_root/tools/bin"
  do
    if [ -d "$abbey_path" ]; then
      case ":$PATH:" in
        *":$abbey_path:"*)
          ;;
        *)
          PATH="$abbey_path:$PATH"
          ;;
      esac
    fi
  done

  export PATH
fi

unset abbey_path abbey_toolkit_root
