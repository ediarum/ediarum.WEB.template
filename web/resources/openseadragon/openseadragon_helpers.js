
function createOSDviewer(id, pic){
    var viewer = OpenSeadragon({
        id: id,
        prefixUrl: "../resources/openseadragon/images/",
        tileSources:   [{
        "@context": "http://iiif.io/api/image/2/context.json",
        "@id": pic,
        "height": 450,
        "width": 300,
        "profile": [ "http://iiif.io/api/image/2/level2.json" ],
        "protocol": "http://iiif.io/api/image",
        "tiles": [{
            "scaleFactors": [ 1, 2, 4, 8, 16, 32 ],
            "width": 1024
            }]
        }]
     });
};
