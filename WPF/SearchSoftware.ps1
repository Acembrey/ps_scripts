# first attempt using WPF to create a GUI for service desk use. Software was managed per department, and was scattered everywhere. This GUI basically allows SD to search all software repos, and copy the path. 
# doing this without VS is a pain, and compiling had mixed results
# overall this is still a funtional script, and SD still uses it to this day. DisplaySoftwarePaths was also modular, so if new repos are added, you can just add the path to the function. 

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main window for the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Search Software"
$form.Size = New-Object System.Drawing.Size(600, 600)
$form.StartPosition = "CenterScreen"
$form.AutoScale = $true

# Create a box that will hold each path from DisplaySoftwarePaths
$SoftwareResults = New-Object System.Windows.Forms.ListBox
$SoftwareResults.Location = New-Object System.Drawing.Point(20, 50)
$SoftwareResults.Size = New-Object System.Drawing.Size(540, 400)

# Text box for searching through $SoftwareResults
$SearchSoftware = New-Object System.Windows.Forms.TextBox
$SearchSoftware.Location = New-Object System.Drawing.Point(20, 20)
$SearchSoftware.Size = New-Object System.Drawing.Size(540, 20)

# Button to copy the selected path
$CopyButton = New-Object System.Windows.Forms.Button
$CopyButton.Text = "Copy Path"
$CopyButton.Location = New-Object System.Drawing.Point(20, 470)
$CopyButton.Size = New-Object System.Drawing.Size(100, 30)

# Paths need to be added to array so that it can then be plugged into a listbox
$global:LabSoftware = @()

# Function that is used to get the full paths to all software paths for each folder path given
Function DisplaySoftwarePaths {
    $LabSoftwarePaths = "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""

    foreach($LabPath in $LabSoftwarePaths){
        $SoftwarePaths = (Get-ChildItem -Recurse -Depth 1 $LabPath).FullName
        $global:LabSoftware += $SoftwarePaths
    }
    
    if($global:LabSoftware){
        $SoftwareResults.Items.AddRange($global:LabSoftware)
    }
}

# Function to make $SearchSoftware function similarly to $compSearchBox
function Filter-Software-Results {
    $searchQuery = $SearchSoftware.Text
    $SoftwareResults.Items.Clear()
    $filteredResults = $global:LabSoftware | Where-Object { $_ -like "*$searchQuery*" }
    if ($filteredResults) {
        $SoftwareResults.Items.AddRange($filteredResults)
    }
}

# Function to copy the selected path to clipboard
function Copy-SelectedPath {
    if ($SoftwareResults.SelectedItem) {
        [System.Windows.Forms.Clipboard]::SetText($SoftwareResults.SelectedItem.ToString())
    }
}

# Add event handlers
$SearchSoftware.add_TextChanged({ Filter-Software-Results })
$CopyButton.add_Click({ Copy-SelectedPath })
$SoftwareResults.add_KeyDown({
    param ($sender, $e)
    if ($e.Control) {
        if ($e.KeyCode -eq [System.Windows.Forms.Keys]::C) {
            Copy-SelectedPath
        }
    }
})

# Add objects to the main window
$form.Controls.Add($SoftwareResults)
$form.Controls.Add($SearchSoftware)
$form.Controls.Add($CopyButton)

# Load all software when form loads
$form.Add_Shown({
    DisplaySoftwarePaths
})

# Call function to start the form
$form.ShowDialog()
