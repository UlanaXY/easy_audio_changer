Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Select-AudioDevice {
  param(
    [object[]]$AudioDevices
  )

  $font = New-Object System.Drawing.Font('Segoe UI', 12)

  $form = New-Object System.Windows.Forms.Form
  $form.Text = 'Data Entry Form'
  $form.Size = New-Object System.Drawing.Size(500,300)
  $form.StartPosition = 'CenterScreen'
  $form.Font = $font

  $OKButton = New-Object System.Windows.Forms.Button
  $OKButton.Location = New-Object System.Drawing.Point(260,220)
  $OKButton.Size = New-Object System.Drawing.Size(100,35)
  $OKButton.Font = $font
  $OKButton.Text = 'OK'
  $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
  $form.AcceptButton = $OKButton
  $form.Controls.Add($OKButton)

  $CancelButton = New-Object System.Windows.Forms.Button
  $CancelButton.Location = New-Object System.Drawing.Point(370,220)
  $CancelButton.Size = New-Object System.Drawing.Size(100,35)
  $CancelButton.Font = $font
  $CancelButton.Text = 'Cancel'
  $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
  $form.CancelButton = $CancelButton
  $form.Controls.Add($CancelButton)

  $label = New-Object System.Windows.Forms.Label
  $label.Location = New-Object System.Drawing.Point(20,20)
  $label.Size = New-Object System.Drawing.Size(440,30)
  $label.Font = $font
  $label.Text = 'Please make a selection from the list below:'
  $form.Controls.Add($label)

  $listBox = New-Object System.Windows.Forms.Listbox
  $listBox.Location = New-Object System.Drawing.Point(20,60)
  $listBox.Size = New-Object System.Drawing.Size(440,160)
  $listBox.Font = $font

  $listBox.SelectionMode = 'One'
  $listBox.DisplayMember = 'Name'
  $listBox.Height = 160

  foreach ($device in $AudioDevices) {
    if ($device.Type -eq "Playback") {
      [void] $listBox.Items.Add([PSCustomObject]@{
        Name = $device.Name
        AudioDevice = $device
      })
    }
  }

  $form.Controls.Add($listBox)
  $form.Topmost = $true

  $result = $form.ShowDialog()

  if ($result -eq [System.Windows.Forms.DialogResult]::OK -and $listBox.SelectedItem) {
    return $listBox.SelectedItem.AudioDevice
  }
}

$device_list = Get-AudioDevice -List
$selectedDevice = Select-AudioDevice $device_list

if ($selectedDevice) {
  Set-AudioDevice $selectedDevice.ID -DefaultOnly | out-null
}



 