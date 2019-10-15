(C) Copyright IBM Corporation 2011, 2016

Automated Measurement of Systems for Temperature and Energy Reporting
README

########################################################################################
Connect to...
  POWER system fsp...       NOTE: FSP based Enterprise systems
    NOTE: need generated security keys to connect.
    P8  Tuleta
        Alpine
        Brazos (Multi Node)
    P9  ZZ


  OpenPOWER...              NOTE: BMC IPMI interface
    P8  Garrison  (AMI BMC)
        Firestone (AMI BMC)
        Palmetto  (AMI BMC)
        Habanero  (AMI BMC)
        Briggs    (Supermicro BMC)
        Stratton  (Supermicro BMC)
    P9  Boston    (Supermicro BMC)


  Open BMC...               NOTE: REST interface
    https://github.com/openbmc/openbmc
    P9  Romulus
        Witherspoon
        Zauis

        NOTE: need OpenBMC version ibm-v2.0-0-r41 or newer for performance improvement.
              https://github.com/openbmc/openbmc
              OpenBMC version : ibm-v2.0-0-r41 or newer.

        NOTE: need OCC version for performance improvements.
              https://github.com/open-power/occ
              master commit : c44bd0f660c708c3e2b2cd7588c56e7c9c92e50c
              Support set data length command to improve AMESTER performance with O…

              op910 commit:  c784d70c98e1cb745215f9e879e29b0bc6faf4e6
              op910 pnor version OP9_v1.19_1.146 or higher

########################################################################################
Automated Measurement of Systems for Temperature and Energy Reporting
is a software tool to remotely collect power, temperature, fan speed,
and performance data from IBM servers and control power management
policies in those servers.  It has interfaces for BladeCenter, POWER,
and x86 rack-mount systems.  It provides functions to 1) download and
graph sensors, 2) read and write any named variables in EnergyScale
firmware, 3) Collect 1 ms resolution traces on any sensor or named
variable, 4) collect 32 ms resolutions traces on SCOM addresses and
correlate them with sensors and named variables, and 5) control remote
jobs to be run on servers. The user can control the tool by writing
scripts in the popular TCL language to automate the operation modes of
the server and collection of data. The tool can attach to multiple
servers simultaneously to enable cluster-level power management
studies.

---------------------
Installation on Linux

Step 1: Download the program from the website
     https://github.com/open-power/amester
Step 2: At the Linux prompt, inside the amester directory
     Type "./configure"
     Type "make"
     Watch the tool build.
Step 3: Run the program in the build directory
     Look in the directory amester/build/ for the binary executable.
     Alternately, you can run directly from the source code by
     typing "run.tcl"


------------------------------
Directions on using the tool

Please run the application and use the "Help" menu
to see the manual.

------------------
Changes to Automated Measurement of Systems for Temperature and Energy Reporting

Changes in version 7.4  2019-10-15
-- Update to support P9 openBMC 2nd REST stack.

Changes in version 7.3  2019-03-12
-- Update to support P9 openBMC systems with Deconfigured Processor.

Changes in version 7.2  2018-03-01
-- Update to add support P9 openBMC systems using HTTP:REST.

Changes in Version 7.1  2017-08-29
-- Update to work with P9 BMC/FSP systems using IPMI/NETC.

Changes in version 7.0  2016-04-01
-- Prepare for open source release.
   Remove older proprietary interfaces.

Changes in version 6.6  2015-10-19
-- AME API 2.28: Add bulk read of parameters
-- OpenPOWER: Correctly detect number of OCC instances on Garrison
-- Remove many deprecated functions (histograms, power management)

Changes in version 6.5  2015-10-07
-- Fix MSGP login method for POWER systems with FSP. Corrects a bug introduced
   in Amester 6.0 that caused MSGP method to not work at all.
-- Update manual to describe how to connect to OpenPOWER systems better.
-- Update manual to include examples of using the job library.

Changes in version 6.4  2015-09-18
-- Correct graph time axis units from seconds to milliseconds.
-- Update default password for OpenPOWER in GUI to reflect current firmware.
-- Fix detection of CPUs in OpenPOWER to parse current firmware FRU list.

Changes in version 6.3  2015-08-11
-- Add AME API 2.27. Provides 64-bit accumulator for sensors.
-- Show debug output for IPMI on OpenPOWER with "::amesterdebug::set ipmi 1"

Changes in version 6.2  2015-07-06
-- Fix queuing of IPMI requests in OpenPOWER systems so callbacks can
   initiate new requests. (Exposed by watchsensors.tcl script)
-- Support OpenPOWER systems with more than 1 OCC by scanning IPMI fru list
   to detect multiple OCC

Changes in version 6.1  2015-04-30
-- Fix --nogui command line option

Changes in version 6.0  2015-04-21
-- Upgrade Tcl/Tk to 8.6.4
-- Upgrade tls package to 1.6.4 (POODLE security update)
-- Upgrade openssl to 1.0.2a (POODLE security update)
-- Add script to build Tcl/Tk and packages from source
-- Add refresh button (column) for each parameter

Changes in version 5.47  2015-2-10
-- Add feature to connect to OpenPOWER systems that use BMC.
-- FIX: watchsensors.tcl displays zero value on first output line.
-- FIX: parameter window displays the complete ame interface name.
-- FIX: <sensorobj> get sensorname {list} can deal with multi-line lists

Changes in version 5.46  2014-9-23
-- FIX: Add explicit timeout if Amester cannot callhome. Fixes problem of Amester
        not starting when home server is not reachable.
-- FIX: Add ability to pause network traffic on systemz and tunasim connections

Changes in version 5.45  2014-9-12
-- FIX: Fix bug in ameclist variable for POWER8
-- Add ability to stop network traffic on POWER connections (pause feature)

Changes in version 5.44  2014-9-9
-- FIX: Detect and connect to multiple drawers in POWER8 correctly.
-- FIX: Run in --nogui mode without crash (fix in tunasim module)

Changes in version 5.43  2014-03-25
-- Job package now copies stderr to stdout. Available in "<job> cget -output"
-- Add module for System z

Changes in version 5.42  2014-01-29
-- Add module for connecting to TMS Tuna Emulator

Changes in version 5.41  2013-11-26
-- Make polling scripts more resilient to network or system failure.
   The sensor polling in Amester is now only allowed to queue one network message at a time.
   When the network or system recovers, this means there are fewer old messages in the queue
   to process.
-- Make POWER8 initial connection only succeed when all OCCs on a node respond. Previously,
   any OCCs that did not respond were silently ignored.
-- Make initial connection to POWER8 tuleta (2 socket, 4 OCC) faster by 46% saving 27 s.
   This is done by caching meta-data requests across OCCs on the same node.
-- Add example file sensorlist.tcl that prints all available sensors

Changes in version 5.40  2013-8-5
-- Fix failure of --nogui option on POWER8.
-- Speed up Amester startup on POWER8. Assumes same OCC firmware level on all POWER8 processors.
   Measured a 44% speedup on 4 OCC system.
-- Changed call home IP address
-- Updated script examples/POWER8/watchsensors.tcl for tracing sensor GUI on POWER8.
-- Add some regression tests

Changes in version 5.39  2013-5-28
-- Update to work on P8 systems with driver b0507a_1321.810
-- Auto-detect P7 or P8 system
-- Use LUN byte in host class to specify OCC number for P8.
-- GUI changes
    Added a cascade for each node found on the connecting target system (P8). Each
    node can have more than one AME objects depending on the number of OCC instances
    found on each node.
      add_node_gui_menu
    Removed "Options", "Power Control", and "Performance Control" functions (P8
    system only.)
-- Changes for AME API 2.26
    Added function to find OCC instance on a target node with netfn 0x2E and cmd 0x3D
      aem_find_occ_instance
    Added function to init AME object with rssa and occ_list as input
      init_ameocc_objects
    Added OCC instance number as the first byte of data field for all request packet
    with netfn 0x3A and cmd 0x3C/0x3B


Changes in version 5.38  2012-12-12
-- Better error messages in trace buffer configuration
-- Update parameter GUI when it is displayed the first time.
-- Fix typo in command that clears sensor min/max value. Command sometimes falied.
-- power7_partition library uses fips760 for AME version >=4, not ==4.
-- New routines in AME API 2.25
   Adding sensors into existing sensor display
     add_sensor_list_by_name
     add_sensor_list_by_object
   Adding parameters into existing parameter display
     gui_add_parm_by_name
     gui_add_parm_by_object
     gui_add_cols
-- Temporary files directory uses PID and UNIX seconds in name to be unique.


Changes in version 5.37  2012-02-13
-- Fix "ERROR: ::myfsp_ame0 sensor_watch_callback status=-1 data=" caused when
   TPMD/network fails during sensor gathering. Now retries to get sensors.
-- Press <Enter> in IP address entry of netc connection GUI to start the connection.
-- Can now specify the parent window of a data object graph.

Changes in version 5.36
-- Remove traceparm.tcl example file. (Use trace.tcl now)
-- Detect more VPD levels for blades (Up to 1.0F)
-- Added library extension to parse core groups (partitions) in POWER7 EnergyScale

Changes in version 5.35
-- Fix bug that caused no output in trace buffer recordings
-- Update trace.tcl example file to automatically detect multi-node systems
   and download traces from each node.

Changes in version 5.34
-- Prepare for external release
--- Use descriptive name
--- Remove unused code and comments
--- Update copyright notice

Changes in version 5.33
-- Delete temporary directory on Tcl exit command.
-- Update multiselect to dynamically resize based on contents
-- Use fonts that are installed on most IBM systems.
-- Remove legend from sensor graphs that only have 1 sensor.

Changes in version 5.32
-- Allow tool to connect to POWER systems using the HMC account
   password by using the NETC protocol "MSGP" tool method.
-- Update manual with examples of how to connect to POWER
   systems.  Documented new netc command options.

Changes in version 5.31
-- Fix bug so that trace buffer recording works on POWER7 IH.

Changes in version 5.30
-- Make connection to development POWER IH TPMD faster
---- Update tool initialization to for API 5.25 so that it does not request
     the histogram snapshot rate for each sensor when the current value is 0.
     The development TPMD has not set the proper value (should be non-zero),
     but this version of tool will deal with it no matter what value it has.

Changes in version 5.29
-- Update for production verion of POWER7 HE. Correctly detect all nodes
   in multi-node systems.

Changes in version 5.28
-- Add API 2.25
--- Fixed serious bug in parameter interface that limited parameters to size of IPMI packet.
-- Do not display "freq" field by default.

Changes in version 5.27
-- Enable POWER7 HE connection.
-- Create widgets on-demand to avoid long shutdown times
-- Add user functions to set parameter gui
--- gui_set_cols, gui_set_parm_by_name, gui_set_parm_by_obj
-- Tracebuffer for API 2.23 and 2.24 now interprets all sensor values as unsigned.
-- Can change "hist" field in sensor GUI window. This sets the number of data points in the graph.
-- Add README.txt to Help menu

Changes in version 5.26
-- Add "All" and "None" buttons to multiselect widget.
-- Make netc network connection more robust
--- Aggressively reconnect after FSP message timeout to reduce
    problem due to flaky network in bringup lab
--- Add "timeout_default" variable to netc object
--- Use new tool name on each reconnect to avoid hitting
    the FSP policy that only allows 1 connection per minute per tool name.
-- Remove debug output on connection to FSP NETC.

Changes in version 5.25  2009-08-18
-- Allow multiple tool sessions to the same POWER system.
-- Enable MR16 multi-draw. Detect number of TPMD and connect to each.
-- Fix bug that caused slow initial connection on POWER.
-- Fix bug in netc checksum for rssa and netfn+lun fields.
-- Speedup formatting of outgoing netc message.
-- Fix bug in synchronous ipmi commands that caused freeze on POWER (netc)

Changes in version 5.24  2009-08-10
-- Fix bug since 5.22 that caused sensors GUI to fail on older firmware.  (Sensor update field was initialized to "" instead of 0 and could not be incremented)
-- Remove spurious "after" output. (Put "return" at end of sensor_window_update routine so after is not the last line)

Changes in version 5.23  2009-08-06
-- Make sensor GUI more responsive.
-- Optimize number of network commands to get multisensor data.
-- Firmware returns true number of sensor updates in "update" field.
   This can be used with the sensor accumulator to compute true averages.
-- Added new public methods for setting sensor GUI
-- Updated manual for new AME component commands

Changes in version 5.22  2009-07-31
-- Add AME API 2.24
--- Update speed of sensor GUI is 46x faster for POWER7
--- Detect maximum size of input/output messages
-- Updates to AME API 2.23
--- add function to return all parameter objects in a sorted list
   <parmobj> get parmobjs
-- Make model-machine-type, model, and serial number available for
   netc objects.
	<netc> cget -mtm, <netc> cget -model, <netc> cget -serial
-- add check for current version

Changes in version 5.21
-- Sensor window displays all sensors as unsigned values.
   There are no signed sensors in POWER7 yet.
-- Add "Clear min/max" button to sensor window
-- Add Parameter GUI to show/edit values
-- Remove getting number of processors.
   This has not been supported in AME/TPMD firmware for awhile.
-- Fix link up/down in GUI for netc (POWER FSP)

Changes in version 5.20
-- Fix bug in parameter parse routine. Use string, not number, for type.
-- Fix bug (did not include tracebuffer update for API 2.23)
-- Do not automatically disconnect (and retry command) if FSP reports an error. Let callback deal with the error.

Changes in version 5.19
-- Add AME API 2.23
--- Add Parameter interface
--- Add parameters to trace interface

Changes in version 5.18
-- Add AME API 2.22
-- Add traces (v3) new in AME v2.22
-- Fix host-level IPMI sensors. Graph windows can be destroyed and re-created.
-- Fix broken argument parsing on Linux (run.tcl is different than binary!)

Changes in version 5.17
-- Add AME API 2.21 (support updated tracebuffer interface)
-- Update tracebuffer to use writeable scoms

Changes in version 5.16
-- Add AME API 2.20 (adds tracebuffer interface)
-- Increase font size in commandline window

Changes in version 5.15
-- Fix broken argument parsing (Linux and Windows send args differently)
-- Arguments to scripts are available in ::script_argv
-- Debug library now can output to file descriptor when GUI is not available.
-- Update Makefile for versions of wget that complain about -N and -O being used together.
-- Fix bug that caused histogram to not read properly after being reconfigured.
-- Periodically send a keepalive command to bladecenter so it won't close connection.
-- If sensor names have a "-", replace with "_".
-- Add get_control_a_sync to get classic P control model parameter
-- Fix bug that caused error when --no-gui is used (tried to add menu items to connect to hosts)
-- Only start amester scope if there the GUI is running. (Otherwise setting the address of a host opens scope
   and causes hang when --nogui is used)
-- Standardize output of ipmicmd across all hosts to print a 2 character hexidecimal completion code for IPMI command when code is non-zero.

Changes in version 5.14
-- Fix bug causing all output to freeze until sensor window was displayed.
-- Fix bug causing nothing to happen when a "select" button is clicked.
   (Converted multiselect windows to itcl to enable multiple multiselects
   to be active at the same time.  Multiselect is now a GUI element package
   that can be used in user scripts.)
-- Add more synchronous commands for histogram configuration to
   avoid the problem of reading the histogram before it is configured.

Changes in version 5.13
-- Add average value field to histogram GUI window.
-- Web build must fetch source from CVS using tag
   (Enforce CVS commit before making a release)

Changes in version 5.12
-- Fixed a bug that caused no sensors to be displayed on systems with more than 128 sensors.
-- Add a GUI to connect to common machine types. On File menu under "Connect to..."

Changes in version 5.11
-- AME v2.17 changes (prototyped in v2.16)
   - Add commands for modifying clockmod (throttle) table
-- AME v2.16 changes
   - Add performance control GUI to manualy select override state
   - Add speed setpoint GUI
   - Update main window GUI so scrolling and resize work better
   - Update GUI for sensor windows
     - Add scrollbars
     - Use a large fixed-size format for some fields to remove "wiggle" problem.
-- Add EMT agent program.  tool connects over TCP/IP to agent running in-band that
   can reply IPMI commands to platform.  This gives a high-speed way to interact with blades
   which are bottle-necked by a single BladeCenter MM using a slow RS485 bus.
-- Turned off debug messages for netc interface. It is considered stable.

Changes in version 5.10
-- AME v2.16 changes
   - Add GUI for controling AME performance parameters
    (manual override and speed setpoint)
   - Add many *_sync access methods for power control parameters which wait
     until IPMI command has finished before returning.
   - Add many *_get access methods to return AME object variables.  These synchronize
     with the AME firmware and return the most recent value in the firmware.
-- Add bc::get_ambient_temp_sync to return ambient temperature from management module.
-- Add netc object for accessing AME functions on HV8 systems
-- Fixed errors that resulted in spurious debug messages being printed.
   (related to MM hangup after timeout and commandline window callbacks.)

Changes in version 5.9
- Upgrade to dqkit-0.10 which includes Tcl 8.4.13
- dqkit is no longer provided in tool CVS due to licensing issues.
  It is downloaded in the Makefile.
- "wget" must be installed to make the tool executable.
- Include Common Public License in LICENSE file.
- Include install-sh, which is required by configure
- Fix Makefile problem so non-developers can build binaries
- Add IBM copyright notices to all files.

Changes in version 5.8
- Add AME API 2.16
- Speedup initialization of a server by 10x.
-- Initialize histograms only on first use of histogram commands.
-- New IPMI commands that combine many old ones
- Scope API 2.16 sends back the pm_state that is used
- Speedup initialization of a 28 blade cluster by over 20x.
-- If a new server is the same type and firmware level, assume
   it has an identical sensor configuration (Reduce number of
   IPMI commands when tool connects)
- Added scrollbars to main window
- Choose unique color/dash/symbol patterns for each server for
  cluster-level graphs.

Changes in version 5.7
- Add commands for set/get speed setpoint
- Add commands for set/get of performance state override.
- Add manual for AME IPMI 2.15.  (new commands for 2.15 only)
- Fix AME API 2.14, 2.13 to use their respective sensor API, not the detected API of the server.

Changes in version 5.6
- Fix BladeCenter networking bug that caused "type=13" errors.
- Add check for capability to send IPMI commands to blades, before initalizing AME component.

Changes in version 5.5
- Bug fix: Fix complete failure of localhost. (bug introduced in 5.3 or 5.4)
- Histograms default to 2 bytes per bin in the entry box (since 0 is not a legal value)
- Make networking more robust.  Does not abort on seeing a Cell-based blade.

Changes in version 5.4
- Bug fix: RMCP on linux works OK. Use UDP library in tcl executable.
- Support API 2.14
- Add timeseries function (API 2.14)
- Improvements to histogram/timeseries window (API 2.14)
   - Print x,y of point nearest to cursor
   - Switch between histogram and timeseries modes
   - Loose axis numbers for timeseries
- Arrow keys move throught histogram/timeseries window data when cursor is inthe window
- tool manual is available by "help" command and menu option.

Changes in version 5.3
- Add support for AME API 2.8
- Add rmcp object.  Use this to connect to hosts that support an IP address for the BMC. For example, IBM x3550 (Defiant).
- New command interface to send IPMI messages to hosts.

Changes in version 5.2
- Add localhost object.  Use this to connect tool to AME running on the local system.
- Restructure code: both blade and localhost use ame and sensor objects (contains).
- Restructure code: Move IPMI and ameutil code to host object

Changes in version 5.1
- Fix sensor window re-draw bugs (on move or close and re-open)
- Add many accessor methods for blade, amec, and sensor objects.
- Add "wait" method to sensor to pause program and wait for update to
  a sensor value or vector
- Add "get histogram" method to sensor to get histogram values and
  bins names.
- Fix bugs in code that reads AME histograms (bugs introduced in 5.0)
- Show machine-type-model and MAC address in main window for each blade.

Changes in version 5.0
- Re-wrote most code in [incr Tcl]
- Added object classes for BladeCenter, blade, AME firmware component, and AME sensor.
- Support AME API 2.12 (recommend using AME 2.96)
--- Power and temperature sensors have 0.1 W and 0.1 C resolution, respectively.
--- Power set points for feedback controller use resolution of 0.1 W.
--- Scope supports 0.1 W resolution
--- Scope no longer supports temperature (You can use normal AME sensors to get CPU temperature).
- Scripts for previous versions of tool will not work. Command format is different due to use of objects. See the tool manual for more information.
--- Only base.tcl and blower.tcl example scripts work with 5.0. Other scripts have not been re-written yet.

Changes in version 4.4
- Changed format of bc command arguments. (Tk style)
- Update histogram high/low values only when configuration is modified and IPMI command succeeds
- Fix bug in histogram window that displayed highest bin value as being in the next-highest bin.
- Rewrite console with itcl
- Load [incr Tcl] package so user scripts can use it.
- Upgrade interpreter to dqkit 0.9. Includes Itcl, Itk, Iwidgets.

Changes in version 4.3

- Update for AME API 2.10:  Modified interface for histograms.  Histograms use a single global enable on BMC.
- Move graph buttons from button bar to a separate menu to reduce screen clutter.
- Change layout of main window. The grid elements no longer have a minimum width.  More results can be shown on the screen.
- set_sensor_list command was added (from ameutil). Select monitored sensors by name.
- All sensor-related commands now use sensor names instead of numbers
- Global variables now use a sensor name. For example, ::sensorinfo(bladename,sensorname,field)
- "bc" command replaces "bc_create"

Changes in version 4.2

- Added new GUI interface for histograms. It lets you change histogram parameters on-the-fly.

Changes in version 4.1

- bug fix: automatic connections to ameutils was disabled by accident.

Changes in version 4.0

- Works with AME 2.60
- New Histogram interface
- Fixed bug in command "ipmicmd" to allow more than 9 byte arguments
- Fixed bug in command "bc_ipmicmd" to allow multiple outstanding BC commands.

Changes in version 3.2

- Make networking to AME Utility and MM more robust. On failure, close connection and retry later.
- If AME Utility returns nothing, then ignore it. Seems to be a problem for AME Server returning data for some benchmarks.
- Only get sensor info/data from AME Utility if there is no MM for the blade. (Do not overwrite sensor column headings)
- Rename "gain" parameter to model "A" parameter to match paper.
- Add command for synchronous ipmi commands:  ipmicmd <bladename> <bytes>

Changes in version 3.1

- Update histograms to have correct labels and scaling for AME 2.50

Changes in version 3.0

- Add control panel for control loop parameters for each blade.
- Consolidate all per-blade functions under a single menu.
- Update graphs to have loose Y-axis (show some axis values above/below the data)
- Add latency/throughput graphs to show benchmark results
- Graphs to show blade budgets
- Graphs to show blade speed
- Examples (example/milestone.tcl) that show how to run workloads with tool and gather results.
- A power shifting algorithm for equalizing CPU speed across a cluster under a given power-cap. Uses a proportional feedback-directed controller.

Changes in version 2.3

- Add --nogui option to run without windows. Works from console with no Xserver. --bg does the same thing.
- Add 64ms power trace in options window
- Add routines to convert traces to ASCII format
- Add analysis routines for files (histograms)
- Fix bug that caused scope to jump to beginning when scope options changed or number of points in window changed.
- Add stream API to tool for reading trace files

Changes in version 2.2

- Add debug element to graph

Changes in version 2.1

- Option to highlight interpolated points in display (or not)
- Fix problem with interpolating more than 255 points

Changes in version 2.0

- Updated to work with AME API 2.17
- Added scope feature
- Fix Makefile to build executables
- First release to website

Changes in version 1.0

- Initial version
- Remotely connect to AME Utility and display measurements
