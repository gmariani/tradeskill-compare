<?PHP

move_uploaded_file($_FILES['Filedata']['tmp_name'], "./profiles/".$_FILES['Filedata']['name']);
chmod("./profiles/".$_FILES['Filedata']['name'], 0777); 


?>