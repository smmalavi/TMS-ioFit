# TMS ioFit

TMS ioFit is an open-source Matlab-based toolbox for closed-loop EMG-guided transcranial magnetic stimulation (TMS), which refers to automatic and real-time adjustment of TMS parameters by using electromyography (EMG) data in a feedback system.

TMS ioFit estimates neural recruitment or input-output (IO) curves and parameters in a closed-loop system, by using the EMG data and  sequential estimation method. In the sequential estimation method, a train of TMS pulses is applied, the estimation is updated after each pulse, and the process continues until the IO curve and parameters are estimated with a desired level of accuracy. The current version of TMS ioFit supports uniform and optimal sampling methods. In the uniform sampling, the intensity of TMS pulses is uniformly distributed. In the optimal sampling method, the intensity of TMS pulses is chosen based on the Fisher information matrix (FIM). In comparison with the uniform sampling method, the FIM-based optimal sampling method results in more accurate estimation of the IO curve and parameters with fewer TMS pulses. 

TMS ioFit was developed by the Department of Psychiatry & Behavioral Sciences, Duke University School of Medicine.

## Hardware and Software

![image](https://user-images.githubusercontent.com/46087039/233884264-30926e12-dc85-491b-9bc1-108ca87080a1.png)

The required hardware and software include:

– TMS stimulator and coil

– EMG recorder. The driver and Matlab interface of the EMG recorder is also needed. 

– A device for the generation of trigger signal. TMS companies might have their own trigger box. 

– MAGIC toolbox

– TMS ioFit toolbox

We tested TMS ioFit by using the MagVenture MagPro X100 device, with the TMSi Mobi Mini EMG recorder. The National Instruments‘ myDAQ University Kit was used for the generation of the trigger signal. The hardware connections are described in the following video. Download and install the TMSi Mobi Mini driver and Matlab interface from here, and the MAGIC toolbox from here. Copy all files of the TMS ioFit toolbox from here to the directory of TMSi_Matlab_Interface\trunk\src. In order to run, write TMS_ioFit in the Matlab workspace. 


## Team
A multidisciplinary research group has been contributing to the design and development of TMS ioFit and its clinical tests and research. TMS ioFit was designed and developed by the Brain Stimulation Engineering Laboratory (BSEL), Department of Psychiatry & Behavioral Sciences, Duke University School of Medicine in 2015. Its automatic and closed-loop version has successfully been tested on the human brain at the Non-Invasive Neurostimulation Therapies (NINET) Laboratory, Department of Psychiatry, Faculty of Medicine, University of British Columbia (UBC) in 2019.


## Editions:

2019: Closed-loop; Automatic analysis and recording of EMG data; Automatic tuning of TMS amplitude; Support of both optimal and uniform sampling methods.

2022: Modified labels of boxes and figures.

## Warranty, Copyright and Licensing: 

The copyrights of this software are owned by Duke University. As such, two licenses to this software are offered:
1- An open source distribution under the MIT license (see below) for non-commercial and academic use only.
2- A custom license with Duke University, for commercial use.
As a recipient of this software, you may choose which license to receive the code under. Outside contributions to the Duke owned code base cannot be accepted unless the contributor transfers the copyright to those changes over to Duke University.
To enter a license agreement for commercial use, please contact the Digital Innovations department at Duke Office of Licensing and Ventures (https://olv.duke.edu/software/) at olvquestions@duke.edu with reference to “OLV File No. 6931” in your email.

Please note that this software is distributed AS IS, WITHOUT ANY WARRANTY; and without the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=== The MIT license ===

Copyright <2020>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.




## Supports: 

For further techncial support, please feel free to contact us at mahdi.alavi.work[at]gmail.com

  
