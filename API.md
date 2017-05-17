#API


## Overview:

| VERB | Location                         | Description                         | Legacy name      |
| ---- | -------------------------------- | ----------------------------------- | ---------------- |
| POST | /synthesizer/synthesize          | Generate avatar file                | gen_3dface       |
| POST | /synthesizer/feature_points      | get synthesizer feature points      |                  |
| POST | /synthesizer/makeover            | Do makeover                         | gen_3dface       |
| POST | /synthesizer/makeover_synthesize | makeover+synthesize                 | gen_3dface       |
| POST | /synthesizer/aging/3d            | Generate aged avatar file           | gen_3dface_aging |
| POST | /synthesizer/aging/2d            | Generate aged avatar file           |                  |
| POST | /analyzer/analyze                | Gather information about the visage |                  |
| POST | /card_detection/detect           | Run card detection                  |                  |
| POST | /synthesizer/moviemaker/shoot    | Generate a movie                    | gen_mkovrmovie   |





**All request must be authenticated with a HTTP Basic Authorization Header.**

---------------------------

## Detail:


### **POST**  */synthesizer/synthesize*
### **POST**  */synthesizer/makeover*
### **POST**  */synthesizer/makeover_synthesize*
### **POST**  */synthesizer/aging/3D*
### **POST**  */synthesizer/aging/2D*

#### Request:


**Common parameters:**

| Name       | Required | Default | Location     | Format      | Description                        |
| ---------- | -------- | ------- | ------------ | ----------- | ---------------------------------- |
|            | Yes      |         | Body         | JPEG or PNG | Input file.                        |
| autodetect | No       | 1       | Query String | Integer     |                                    |
| format     | No       | BIN     | Query String | String      | Format of 3D face mode(SWF         |
| texsize    | No       | 512     | Query String | Integer     | Size of texture(4096               |
| modelsize  | No       | 256     | Query String | Integer     | Model size of texture(2048         |
| eyekeep    | No       | 1       | Query String | Integer     | 1: use photo eye, 0: use CG Eye    |
| expand     | No       | 16      | Query String | Integer     | Expend level                       |
| blur       | No       | 64      | Query String | Integer     | Blur level                         |
| facepos    | No       | 0.5     | Query String | Float       | Position of face center(-1.0 - 1.0) |
| facesize   | No       | 0.5     | Query String | Float       | face size (-1.0 - 1.0)              |
| cropmargin | No       | 1       | Query String | Integer     |                                    |
| backphoto  | No       | 1       | Query String | Integer     |                                    |
| face_fp    | No       | true    | Query String | Boolean     | Wether cosme feature points should be added|


** Extra parameters for POST** */synthesize\**


| Name               | Required | Default | Location         | Format  | Description |
| ------------------ | -------- | ------- | ---------------- | ------- | ----------- |
| contour_equal_face | No       | 0       | Query String     | Integer |             |
| feature_points     | No       |         | Body (multipart) | JSON    |             |


** Extra parameters for POST** */makeover\**

| Name       | Required | Default | Location     | Format | Description |
| ---------- | -------- | ------- | ------------ | ------ | ----------- |
| mkovrmodel | Yes      |         | Query String | String |             |


** Extra parameters for POST**  */synthesizer/aging/*


| Name    | Required | Default | Location     | Format | Description |
| ------- | -------- | ------- | ------------ | ------ | ----------- |
| skindir | Yes      |         | Query String | String |             |


#### Response for: */synthesizer/\**


| HTTP Response            | Encoding | MIME             | Content                      |
| ------------------------ | -------- | ---------------- | ---------------------------- |
| 200 OK                   | base64   | text/html        | The output file              |
| 422 Unprocessable Entity | JSON     | application/json | A JSON with an error message |


#### Response for: */synthesizer/feature_points*


| HTTP Response            | Encoding | MIME             | Content                      |
| ------------------------ | -------- | ---------------- | ---------------------------- |
| 200 OK                   | JSON     | application/json | The feature points           |
| 422 Unprocessable Entity | JSON     | application/json | A JSON with an error message |


Sample response:

    {
        "face": [
            {
                "x": 202.714098,
                "y": 108.67266000000001
            },
            ...
        ],
        "right_eye_inside": [
            {
                "x": 268.44954,
                "y": 225.203616
            },
            ...
        ],
        "left_eye_inside": [
            ...
            ],
        "mouth": [
            ...
        ],
        "right_eye_outside": [
            ...
        ],
        "left_eye_outside": [
            ...
        ],
        "body": [
            ...
        ]
    }


#### Response for: */synthesizer/aging/3d*

| HTTP Response            | Encoding | MIME             | Content                             |
| ------------------------ | -------- | ---------------- | ----------------------------------- |
| 200 OK                   | JSON     | application/json | A JSON with URLs for all resources. |
| 422 Unprocessable Entity | JSON     | application/json | A JSON with an error message        |

Sample response:

		{
		  "bin" : "http://domain.tld/XXX/avatar.bin",
		  "old" {
		  	"bin" : "http://domain.tld/XXX/hige_mesh.bin,
		  	"png" : "http://domain.tld/XXX/hige.png"
		  },
		  "young" {
		  	"bin" : "http://domain.tld/XXX/hige_mesh.bin",
		  	"png" : "http://domain.tld/XXX/hige.png"
		  }
		}

#### Response for: */synthesizer/aging/2d*

| HTTP Response            | Encoding | MIME             | Content                      |
| ------------------------ | -------- | ---------------- | ---------------------------- |
| 200 OK                   | PNG      | image/png        | An aged image                |
| 422 Unprocessable Entity | JSON     | application/json | A JSON with an error message |

### **POST**  */analyzer/analyze*

#### Request:


**Parameters:**

| Location | Format | Name | Required | Content                     |
| -------- | ------ | ---- | -------- | --------------------------- |
| Body     | JPEG   | N/A  | Yes      | The face picture to process |



#### Response:


| HTTP Response            | Encoding | MIME             | Value                        |
| ------------------------ | -------- | ---------------- | ---------------------------- |
| 200 OK                   | JSON     | application/json | The result in a JSON format  |
| 422 Unprocessable Entity | JSON     | application/json | A JSON with an error message |


An example return value would be:

		{
		  "FEMALE": 18.548828,
		  "GLASSES": -19.415039,
		  "AGE": -1.751953,
		  "BEARD": -19.568848,
		  "MUSACHE": -36.700684,
		  "HAIR_LONG": -3.681641,
		  "HAIR_FOREHEAD": -6.575684,
		  "SMILE": -15.791504
		}

Or with feature points:

        {
            "feature_points": {
                "FP_BASICPARTS_EYE_LEFT": {
                    "x": 107,
                    "y": 141
                },
                "FP_BASICPARTS_EYE_RIGHT": {
                "x": 167,
                "y": 155,
                }
        [...]
        },
        "FEMALE": 18.548828,
        "GLASSES": -19.415039,
        "AGE": -1.751953,
        "BEARD": -19.568848,
        "MUSACHE": -36.700684,
        "HAIR_LONG": -3.681641,
        "HAIR_FOREHEAD": -6.575684,
        "SMILE": -15.791504
    }

The list of feature points is:

        FP_BASICPARTS_EYE_LEFT
        FP_BASICPARTS_EYE_RIGHT
        FP_BASICPARTS_EYEBROW_LEFT
        FP_BASICPARTS_EYEBROW_RIGHT
        FP_BASICPARTS_NOSE_BOTTOM
        FP_BASICPARTS_MOUTH
        FP_BASICFACE_UP
        FP_BASICFACE_BOTTOM
        FP_BASICFACE_LEFT
        FP_BASICFACE_RIGHT
        FP_EYE_LEFT_UP
        FP_EYE_LEFT_BOTTOM
        FP_EYE_LEFT_INSIDE
        FP_EYE_LEFT_OUTSIDE
        FP_EYE_RIGHT_UP
        FP_EYE_RIGHT_BOTTOM
        FP_EYE_RIGHT_INSIDE
        FP_EYE_RIGHT_OUTSIDE
        FP_EYEBALL_LEFT_INSIDE
        FP_EYEBALL_LEFT_OUTSIDE
        FP_EYEBALL_RIGHT_INSIDE
        FP_EYEBALL_RIGHT_OUTSIDE
        FP_EYEBROW_LEFT_UP_INSIDE
        FP_EYEBROW_LEFT_UP_CENTER
        FP_EYEBROW_LEFT_UP_OUTSIDE
        FP_EYEBROW_LEFT_LOW_INSIDE
        FP_EYEBROW_LEFT_LOW_CENTER
        FP_EYEBROW_LEFT_LOW_OUTSIDE
        FP_EYEBROW_RIGHT_UP_INSIDE
        FP_EYEBROW_RIGHT_UP_CENTER
        FP_EYEBROW_RIGHT_UP_OUTSIDE
        FP_EYEBROW_RIGHT_LOW_INSIDE
        FP_EYEBROW_RIGHT_LOW_CENTER
        FP_EYEBROW_RIGHT_LOW_OUTSIDE
        FP_NOSE_LEFT
        FP_NOSE_RIGHT
        FP_NOSE_NOSTRIL_LEFT
        FP_NOSE_NOSTRIL_RIGHT
        FP_NOSE_CAVE_LEFT
        FP_NOSE_CAVE_RIGHT
        FP_MOUTH_LEFT
        FP_MOUTH_RIGHT
        FP_MOUTH_UPPER_LIP_INSIDE
        FP_MOUTH_UPPER_LIP_OUTSIDE
        FP_MOUTH_LOWER_LIP_INSIDE
        FP_MOUTH_LOWER_LIP_OUTSIDE
        FP_CONTOUR_EYE_LEFT
        FP_CONTOUR_EYE_RIGHT
        FP_CONTOUR_CHEEK_LEFT
        FP_CONTOUR_CHEEK_RIGHT
        FP_CONTOUR_MOUTH_LEFT
        FP_CONTOUR_MOUTH_RIGHT
        FP_CONTOUR_UPPER_CHIN_LEFT
        FP_CONTOUR_UPPER_CHIN_RIGHT
        FP_CONTOUR_LOWER_CHIN_LEFT
        FP_CONTOUR_LOWER_CHIN_RIGHT



### **POST**  */synthesizer/moviemaker/shoot*


#### Request:
##### Step 1:

A multi part encoded request.

vclip points to a directory on the server organized like this:

├── content0
│   ├── anim.ani2
│   ├── face.mko
│   └── faceanim.txt
├── content1 #if you need multiple faces input only
│   ├── anim.ani2
│   ├── face.mko
│   └── faceanim.txt
├── music.mp3
└── video
├── 00000.jpg
├── 00001.jpg
├── ...


##### Parameters:

| Name       | Required | Default | Location     | Format  | Description                     |
| ---------- | -------- | ------- | ------------ | ------- | ------------------------------- |
| img0       | Yes      |         | Body         |         |                                 |
| img1       | No       |         | Body         |         |                                 |
| img2       | No       |         | Body         |         |                                 |
| img3       | No       |         | Body         |         |                                 |
| vclip      | Yes      |         | Query String | String  |                                 |
| eyekeep    | No       | 1       | Query String | Integer | 1: use photo eye, 0: use CG Eye |
| ofps       | No       | 24      | Query String | Integer |                                 |
| vformat    | No       | flv     | Query String | String  | flv/mov/mp4 supported           |
| vsize      | No       | ""      | Query String | String  |                                 |
| fps        | No       | 24      | Query String | Integer |                                 |
| vbitrate   | No       | 96000   | Query String | Integer |                                 |
| abitrate   | No       | 12200   | Query String | Integer |                                 |
| qscale     | No       | 5       | Query String | Integer |                                 |
| plycnt     | No       |         | Query String | Integer |                                 |
| streaming  | No       |         | Query String | Integer |                                 |
| ffmpeg_opt | No       |         | Query String | String  |                                 |
| saturation | No       | 50      | Query String | Integer |                                 |
| ovrimgzip  | No       |         | Query String | Integer |                                 |
| ovrlay     | No       |         | Body         |         |                                 |


#### Response:


| HTTP Response            | Encoding | MIME             | Value                           |
| ------------------------ | -------- | ---------------- | ------------------------------- |
| 200 OK                   | JSON     | application/json | {"uid":"an uid"}                |
| 422 Unprocessable Entity | JSON     | application/json | An error message in JSON format |


#### Step 2:

The UID obtained in Step 1 should be used to perform pooling on the resource, with the following request:

#### **GET**  */synthesizer/moviemaker/UID*


#### Response:


| HTTP Response            | Encoding        | MIME             | Value/Description                        |
| ------------------------ | --------------- | ---------------- | ---------------------------------------- |
| 200 Ok                   | Depend on input | Depend on input  | The movie requested                      |
| 202 Accepted             |                 |                  | The resource is not yet ready. Retry later |
| 422 Unprocessable Entity | JSON            | application/json | An error message in JSON format. Do not retry |
| 404 Not found            |                 |                  | Resource not found. Do not retry. Possible causes: unknow error/UID/ file removed |


### **POST**  */card_detection/detect*

#### Request:

Request should contain a picture in the body.

#### Response:

    {
        "pd" : 107.730774,
        "debug_picture" : "http://domain.tld/an_url_to_the_picture.png
    }



## Error messages

The error json output respect the following format:

	{
		"error" : {
			"code" : 42,
			"message" : "an error description"
		}
	}


###Possible errors


| Code | Description             |
| ---- | ----------------------- |
| 1    | Invalid parameter       |
| 2    | Unknow error happened   |
| 3    | Face recognition failed |
