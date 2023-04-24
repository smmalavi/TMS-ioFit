# TMS ioFit

TMS ioFit is an open-source Matlab-based toolbox for fast, accurate and automated estimation of neural recruitment or input-output (IO) curves and parameters with closed-loop transcranial magnetic stimulation (TMS) based on the Fisher information matrix (FIM) optimal sampling method. In the FIM-based optimal sampling method, the intensity of TMS pulses is chosen optimally from the location of maximum information. 

TMS ioFit administers a train of TMS pulses, updates the estimation after each pulse, and continues the process until the IO curve and parameters are estimated with a desired level of accuracy.

TMS ioFit also supports the IO curve estimation by using the conventional uniform sampling method, where the intensity of TMS pulses is uniformly distributed.  

In comparison with the uniform sampling method, the FIM-based optimal sampling method results in more accurate estimation of the IO curve and parameters with fewer TMS pulses. 

The fundamentals of FIM based IO curve estimation has been discussed in [1]. 

TMS ioFit was developed by the Department of Psychiatry & Behavioral Sciences, Duke University School of Medicine.

## Editions log

2019: Closed-loop; Automatic analysis and recording of EMG data; Automatic tuning of TMS amplitude; Support of both optimal and uniform sampling methods.

2022: Modified labels of boxes and figures.

## Hardware and Software

![image](https://user-images.githubusercontent.com/46087039/233884264-30926e12-dc85-491b-9bc1-108ca87080a1.png)

The required hardware and software include:

– TMS stimulator and coil

– EMG recorder. The driver and Matlab interface of the EMG recorder is also needed. 

– A device for the generation of trigger signal. TMS companies might have their own trigger box. 

– [MAGIC toolbox](https://github.com/nigelrogasch/MAGIC/wiki/) [2]

– [TMS ioFit toolbox](https://github.com/smmalavi/TMS-ioFit/)

Currently, we developed TMS ioFit to the [MagVenture MagPro X100 device](https://www.magventure.com/), with the [TMSi Mobi Mini EMG recorder](https://www.tmsi.com/). The [National Instruments myDAQ University Kit](https://www.ni.com/en-ca/shop/select/mydaq-student-data-acquisition-device?modelId=134166/) was used for the generation of the trigger signal. Download and install the TMSi Mobi Mini driver and Matlab interface from [here](https://www.tmsi.com/), and the MAGIC toolbox from [here](https://github.com/smmalavi/TMS-ioFit-2019). Copy all files of the TMS ioFit toolbox from here to the directory of TMSi_Matlab_Interface\trunk\src. 

In order to run, write TMS_ioFit in the Matlab workspace. 

## Overall Estimation Algorithm

The following figure summarizes the algorithm used in TMS ioFit. It starts with baseline data collection from electromyography (EMG) in the absence of TMS pulses. The baseline data help estimate the lower plateau of the IO curve. For the optimal sampling method, three initial TMS pulses are then administered, chosen randomly between the minimum and maximum pulse strengths. The MEP generated by each TMS pulse is recorded, and the peak-to-peak MEP amplitude is measured and log-transformed to normalize the amplitude distribution. These baseline and initial stimulus–response data serve to generate an initial estimate of the IO parameters. The underlying curve-fitting includes bad-fit detection features to avoid estimation instabilities. The strength of the next TMS pulse is computed by maximization of the Fisher information matrix. After each stimulus, the IO parameter estimation is updated with the latest baseline and stimulus–response data. A stopping rule is checked to terminate the estimation process if all parameter values converge for a specified number of consecutive pulses. This means that for all parameters, the absolute value of the estimations difference between consecutive pulses must be less than a tolerance, and repeated for a specified number of times that is defined by the user. The estimation accuracy is adjustable by the stopping rule parameters. If the stopping rule is not satisfied, the estimation will stop at a pre-defined maximum number of pulses.

### Setting TMS devices and EMG recorders
Presently, TMS ioFit is implemented to interface with MagPro TMS devices, but with minor modifications the code can interface with other devices (Magstim, DuoMag) supported by the MAGIC control toolbox, as described in the figure. 

Likewise, other EMG devices can be connected by modifying the code as described in the figure. 

[This file](https://github.com/smmalavi/TMS-ioFit/blob/master/Triggering_PulseAdmin_emgRecordingFilteringPPcal.txt) provides the line-by-line code and information about setting TMS, NI DAQ and Mobi Mini devices, triggering, pulse administration, EMG recording, filtering, and peak-to-peak calculation. This process is run for all TMS pulses.  

[This tutorial](http://mahdialavi.com/index.php/tutorial-external-control-of-tms-device-by-using-magic-toolbox/) provides examples how the TMS device is controlled externally by using the MAGIC toolbox from Matlab. Depending on the device, magventure(‘COMx’), magstim(‘COMx’) or doumag(‘COMx’) must be used.

![image](https://user-images.githubusercontent.com/46087039/233884780-23285143-0548-4f7c-96eb-63ffe6b9baf8.png)

## Demonstration Videos 

#### IO curve estimation using TMS ioFit optimal sampling
<a href="http://www.youtube.com/watch?feature=player_embedded&v=Kn1R224f_fs" target="_blank">
 <img src="http://img.youtube.com/vi/Kn1R224f_fs/hqdefault.jpg" alt="IO curve estimation using optimal sampling" width="420" height="315" border="10" />
</a>

#### IO curve estimation using TMS ioFit uniform sampling
<a href="http://www.youtube.com/watch?feature=player_embedded&v=w3zpD6oQbhs" target="_blank">
 <img src="http://img.youtube.com/vi/w3zpD6oQbhs/hqdefault.jpg" alt="IO curve estimation using uniform sampling" width="420" height="315" border="10" />
</a>

## Team

A multidisciplinary research group has been contributing to the design and development of TMS ioFit and its clinical tests and research. TMS ioFit was designed and developed by the [Brain Stimulation Engineering Laboratory (BSEL)](https://sites.google.com/view/bsel/), Department of Psychiatry & Behavioral Sciences, Duke University School of Medicine in 2015. Its automatic and closed-loop version has successfully been tested on the human brain at the [Non-Invasive Neurostimulation Therapies (NINET) Laboratory](https://ninet.med.ubc.ca/), Department of Psychiatry, Faculty of Medicine, University of British Columbia (UBC) in 2019.

### Core Members (A-Z)

- S.M.Mahdi Alavi, PhD
- Stefan Goetz, PhD
- Angel Peterchev, PhD
- Fidel Vila-Rodriguez, MD, PhD, FRCPC, FAPA

### Students (A-Z)

- Meghan Chen (Co-Op Student), University of British Columbia
- Judy Cheng (Co-Op Student), University of British Columbia
- Leila Noorbala (PhD Student), Shahid Beheshti University

## Warranty, Copyright and Licensing

The copyrights of this software are owned by Duke University. As such, two licenses to this software are offered:
1- An open source distribution under the MIT license (see below) for non-commercial and academic use only.
2- A custom license with Duke University, for commercial use.
As a recipient of this software, you may choose which license to receive the code under. Outside contributions to the Duke owned code base cannot be accepted unless the contributor transfers the copyright to those changes over to Duke University.
To enter a license agreement for commercial use, please contact the Digital Innovations department at [Duke Office of Licensing and Ventures](https://olv.duke.edu/software/) at olvquestions@duke.edu with reference to “OLV File No. 6931” in your email.

Please note that this software is distributed AS IS, WITHOUT ANY WARRANTY; and without the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

### The MIT license 

Copyright <2020>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Acknowledgement  

![image](https://user-images.githubusercontent.com/46087039/233974086-42ce71e1-6816-4b63-84ad-59f90f3e3a3a.png)

## Supports

For further techncial support, please feel free to contact us at mahdi.alavi.work[at]gmail.com

## References 
[1] SMM Alavi, SM Goetz, AV Peterchev, “Optimal estimation of neural recruitment curves using Fisher information: Application to Transcranial Magnetic Stimulation,” IEEE Transactions on Neural Systems and Rehabilitation Engineering, 27(6), pp. 1320 – 1330, 2019.

[2] F.H. Saatlou, N.C. Rogasch, M. Biabani, N.A. McNair, S.D. Pillen, T.R. Marshall, and T. O. Bergmann, “MAGIC: An open-source MATLAB toolbox for external control of transcranial magnetic stimulation devices,” Brain Stimulation, Vol. 11, pp. 1189 – 1191, 2018.

### Further Readings
- SMM Alavi, A Mahdi, F Vila-Rodriguez, SM Goetz, “Identifiability analysis and noninvasive online estimation of the first-order neural activation dynamics in the brain with closed-loop transcranial magnetic stimulation,” IEEE Transactions on Biomedical Engineering, 2023 (In Press).
- SMM Alavi, F Vila-Rodriguez, A Mahdi, SM Goetz, “Closed-loop optimal and automatic tuning of pulse amplitude and width in EMG-guided controllable transcranial magnetic stimulation,” Biomedical Engineering Letters, 2023. (In Press)
- SMM Alavi, F Vila-Rodriguez, A Mahdi, SM Goetz, “A formalism for sequential estimation of neural membrane time constant and input–output curve towards selective and closed-loop transcranial magnetic stimulation,” Journal of Neural Engineering, 19, 056017, 2022.
- SMM Alavi, SM Goetz, M Saif, “Input-Output Slope Curve Estimation in Neural Stimulation Based on Optimal Sampling Principles,” Journal of Neural Engineering, 18(4), 046071, 2021.
