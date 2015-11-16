#Include <definitions>
#Include <logger>
#Include <config>


config_iniRead() {
    global 0
    global MT_CONFIG_PATH
    global MT_SELECT_PATH
    logger_Log("Parameter Count:" . %0%)
    IniRead, mtCount, MT_CONFIG_PATH, %1%, MT_Count
    IniRead, port, MT_CONFIG_PATH, %1%, PORT_INDEX
    IniRead, dbIndex, MT_CONFIG_PATH, %1%, DB_LIST_NUM
    IniRead, mode, MT_CONFIG_PATH, %1%, MODE
    IniRead, vlanIndex, MT_CONFIG_PATH, %1%, VLAN_INDEX
    IniRead, langIndex, MT_CONFIG_PATH, %1%, LANG_INDEX
    Loop, %mtCount%
    {
        IniRead, SNR_Array[%A_Index%], MT_CONFIG_PATH, %1%, Scenario%A_Index%
        IniRead, card_ID%A_Index%, MT_CONFIG_PATH, %1%, CARD_ID%A_Index%
    }


    resetMTSettings(mode)

    if mtCount > 9
    {
        iniSection := "MT_" . %A_Index%

    }
    Else
    {
        iniSection := "MT_0" . %A_Index%
    }

    Loop, %mtCount%
    {
        IniWrite, 1, MT_SELECT_PATH, iniSection, CHECKED
        IniWrite, mode, MT_SELECT_PATH, iniSection, MODE
        IniWrite, card_ID%A_Index%, MT_SELECT_PATH, iniSection, CARD_ID
        IniWrite, port, MT_SELECT_PATH, iniSection, PORT_INDEX

    }
}

resetMTSettings(mode) {
    global MT_MAX

    mode := mode ? "LTE_CARD_ID" : "3G"
    Loop, %MT_MAX%
    {
        if A_Index > 9
        {
            MTNumber := %A_Index%
        }
        Else
        {
            MTNumber := "0" . %A_Index%
        }
        MTSection := "MT_" . MTNumber
        cardSection := mode . "_" . iniSection
        IniWrite, 0, MT_SELECT_PATH, MTSection, Checked
        IniWrite, 0, MT_SELECT_PATH, cardSection, Endian
    }
}
