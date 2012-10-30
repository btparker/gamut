var pjs;

function startScan(){
    
    pjs.scanImage();
}

function handleFileSelect(evt) {
    if(!pjs){
        pjs = Processing.getInstanceById('gamut');
    }
    
    var files = evt.target.files; // FileList object
    
    // Loop through the FileList and render image files as thumbnails.
    for (var i = 0, f; f = files[i]; i++) {
        
        // Only process image files.
        if (!f.type.match('image.*')) {
            continue;
        }
        
        var reader = new FileReader();
        
        // Closure to capture the file information.
        reader.onload = (function(theFile) {
                return function(e) {
                    // Render thumbnail.  
                    pjs.uploadImage(e.target.result);
                    
                };
            })(f);
        
        // Read in the image file as a data URL.
        reader.readAsDataURL(f);
    }
}



document.getElementById('files').addEventListener('change', handleFileSelect, false);