Function Convert-Hex ($dns) {
	$arr1= $dns -split "\,"
	foreach ($a1 in $arr1) {
		#$a1
		$arr2 = $a1 -split "\."
		# convert each word to hex
		$c = @()
		Foreach ($a2 in $arr2) {
			$word_length = $a2.Length
			$b=@()
			$b += $word_length
			$b += $a2.ToCharArray()
			
			Foreach ($element in $b) {
				$hex = "0x" + [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($element))
				$c += $hex
			}
			
		}
		$c += "0x0"
        $c
	}
}

$output = Convert-Hex "ad.example.com,example.com"

$serverarr=@("dhcp1")

$serverarr | % {
    "Setting DHCP option 119 for " + $_
    Add-DhcpServerv4OptionDefinition -Name "Domain Search List" -Description "Domain Suffix Search Order" -ComputerName $_ -OptionId 119 -Type Byte -MultiValued -DefaultValue 0
    Set-DhcpServerv4OptionValue -OptionId 119 -Value $output -ComputerName $_
} 

