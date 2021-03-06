#Include <logger>
#Include <errorhandler>

global WAIT_DEFAULT_TIMEOUT := 2
global EXECUTION_TAB := 2
global MAX_NO_OF_TRIES := 3
global SUCCESS := 0
global FAILED := 1


; ===============================
; From "Edit Scenario" Tab 
; To "Execute Scenario" Tab
; preparing for scenario execution
; ===============================

exec_ScenarioExecution() {

    WinGetTitle, TEST, ahk_class TFM_MSEDIT
    errorhandler_WinWaitClose("" . TEST . " ahk_class TFM_SFR")

    logger_log("Changing to Execution Page...`n")

    BlockInput, On
    ControlFocus, TPageControl1, %TEST% ahk_class TFM_MSEDIT
    ControlGet, OutputVar, Tab,, TPageControl1, ahk_class TFM_MSEDIT
    
    retryCount := 0
    loop,
    {
        If (OutputVar = EXECUTION_TAB)
        {
            logger_log("Successfully change to Execution Tab...")
            break
        }
        Else
        {

            logger_log("Sending (Ctrl+tab) to change active page.")
            ControlFocus, TPageControl1, %TEST% ahk_class TFM_MSEDIT
            ControlSend,TPageControl1, {CtrlDown}{Tab}{CtrlUp}, ahk_class TFM_MSEDIT
            ControlGet, OutputVar, Tab,, TPageControl1, ahk_class TFM_MSEDIT

            retryCount++
            sleep WAIT_DEFAULT_TIMEOUT
        }

        If (retryCount = MAX_NO_OF_TRIES)
        {
            logger_log("Exceed retry limit."retryCount)
            Break
        }
    }

    ;Enabling the Auto save button for saving logs
    ret_code := errorhandler_BtnClick("TButton20", "Auto Save on", "Auto Save off", TEST, " ahk_class TFM_MSEDIT")
    if (ret_code = SUCCESS)
    {
        logger_log("Auto Save logs is Enabled.")
    }
    Else
    {
        logger_log("Auto Save logs is Disabled.")
    }

    ; exec_ScenarioExecute(TEST)

        
}



;Click Scenario execute
exec_ScenarioExecute(mt_ProcessID) {

    WinActivate, ahk_class TFM_MSEDIT %mt_ProcessID%
    ControlFocus, TPageControl1, ahk_class TFM_MSEDIT %mt_ProcessID%

    ControlGet, OutputVar, Tab,, TPageControl1, ahk_class TFM_MSEDIT %mt_ProcessID%
    WinGetTitle, mt_Name, ahk_class TFM_MSEDIT %mt_ProcessID%
    logger_log("MT Title :  "mt_Name)
    logger_log("Process : "mt_ProcessID)

    if (OutputVar = EXECUTION_TAB)
    {
        ret_code := errorhandler_BtnClick("TButton5", "Scenario execute", "Terminate scenario", mt_Name, mt_ProcessID)
    }

    if (ret_code = SUCCESS)
    {
        logger_log("Successfully clicked Scenario execute :"mt_Name)
    }
    Else
    {
        logger_log("Unsuccessfully clicked Scenario execute :"mt_Name)
    }
}
