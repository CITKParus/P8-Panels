/*
    Парус 8 - Панели мониторинга
    Контекст: Сообщения
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useReducer, createContext, useCallback } from "react"; //ReactJS
import PropTypes from "prop-types"; //Контроль свойств компонента
import { P8PAppProgress } from "../components/p8p_app_progress"; //Индикатор процесса
import { P8PAppMessage, P8PAppInlineMessage, P8PAppInlineError, P8PAppInlineWarn, P8PAppInlineInfo } from "../components/p8p_app_message"; //Диалог сообщения
import { MSG_AT, MSG_TYPE, INITIAL_STATE, messagingReducer } from "./messaging_reducer"; //Редьюсер состояния

//---------
//Константы
//---------

//Структура объекта с описанием типовых заголовков
const MESSAGING_CONTEXT_TITLES_SHAPE = PropTypes.shape({
    ERR: PropTypes.string.isRequired,
    WARN: PropTypes.string.isRequired,
    INFO: PropTypes.string.isRequired
});

//Структура объекта с описанием типовых текстов
const MESSAGING_CONTEXT_TEXTS_SHAPE = PropTypes.shape({
    LOADING: PropTypes.string.isRequired
});

//Структура объекта с описанием типовых кнопок
const MESSAGING_CONTEXT_BUTTONS_SHAPE = PropTypes.shape({
    CLOSE: PropTypes.string.isRequired,
    OK: PropTypes.string.isRequired,
    CANCEL: PropTypes.string.isRequired
});

//----------------
//Интерфейс модуля
//----------------

//Контекст сообщений
export const MessagingСtx = createContext();

//Провайдер контекста сообщений
export const MessagingContext = ({ titles, texts, buttons, children }) => {
    //Подключим редьюсер состояния
    const [state, dispatch] = useReducer(messagingReducer, INITIAL_STATE);

    //Отображение загрузчика
    const showLoader = useCallback(message => dispatch({ type: MSG_AT.SHOW_LOADER, payload: message }), []);

    //Сокрытие загрузчика
    const hideLoader = useCallback(() => dispatch({ type: MSG_AT.HIDE_LOADER }), []);

    //Отображение сообщения
    const showMsg = useCallback(
        (type, text, msgOnOk = null, msgOnCancel = null) => dispatch({ type: MSG_AT.SHOW_MSG, payload: { type, text, msgOnOk, msgOnCancel } }),
        []
    );

    //Отображение сообщения - ошибка
    const showMsgErr = useCallback((text, msgOnOk = null) => showMsg(MSG_TYPE.ERR, text, msgOnOk), [showMsg]);

    //Отображение сообщения - информация
    const showMsgInfo = useCallback((text, msgOnOk = null) => showMsg(MSG_TYPE.INFO, text, msgOnOk), [showMsg]);

    //Отображение сообщения - предупреждение
    const showMsgWarn = useCallback((text, msgOnOk = null, msgOnCancel = null) => showMsg(MSG_TYPE.WARN, text, msgOnOk, msgOnCancel), [showMsg]);

    //Сокрытие сообщения
    const hideMsg = useCallback(
        (cancel = false) => {
            dispatch({ type: MSG_AT.HIDE_MSG });
            if (!cancel && state.msgOnOk) state.msgOnOk();
            if (cancel && state.msgOnCancel) state.msgOnCancel();
        },
        [state]
    );

    //Отработка нажатия на "ОК" в сообщении
    const handleMessageOkClick = () => {
        hideMsg(false);
    };

    //Отработка нажатия на "Отмена" в сообщении
    const handleMessageCancelClick = () => {
        hideMsg(true);
    };

    //Встраиваемое сообщение
    const InlineMsg = useCallback(props => P8PAppInlineMessage({ okBtn: true, okBtnCaption: buttons.OK, ...props }), [buttons.OK]);

    //Встраиваемое сообщение об ошибке
    const InlineMsgErr = useCallback(props => P8PAppInlineError({ okBtn: true, okBtnCaption: buttons.OK, ...props }), [buttons.OK]);

    //Встраиваемое сообщение с информацией
    const InlineMsgInfo = useCallback(props => P8PAppInlineInfo({ okBtn: true, okBtnCaption: buttons.OK, ...props }), [buttons.OK]);

    //Встраиваемое сообщение с предупреждением
    const InlineMsgWarn = useCallback(props => P8PAppInlineWarn({ okBtn: true, okBtnCaption: buttons.OK, ...props }), [buttons.OK]);

    //Вернём компонент провайдера
    return (
        <MessagingСtx.Provider
            value={{
                MSG_TYPE,
                showLoader,
                hideLoader,
                showMsg,
                showMsgErr,
                showMsgInfo,
                showMsgWarn,
                hideMsg,
                InlineMsg,
                InlineMsgErr,
                InlineMsgInfo,
                InlineMsgWarn,
                msgState: state
            }}
        >
            {state.loading ? <P8PAppProgress open={true} text={state.loadingMessage || texts.LOADING} /> : null}
            {state.msg ? (
                <P8PAppMessage
                    open={true}
                    variant={state.msgType}
                    text={state.msgText}
                    title
                    titleText={state.msgType == MSG_TYPE.ERR ? titles.ERR : state.msgType == MSG_TYPE.WARN ? titles.WARN : titles.INFO}
                    okBtn={true}
                    onOk={handleMessageOkClick}
                    okBtnCaption={[MSG_TYPE.ERR, MSG_TYPE.INFO].includes(state.msgType) ? buttons.CLOSE : buttons.OK}
                    cancelBtn={state.msgType == MSG_TYPE.WARN}
                    onCancel={handleMessageCancelClick}
                    cancelBtnCaption={buttons.CANCEL}
                />
            ) : null}
            {children}
        </MessagingСtx.Provider>
    );
};

//Контроль свойств - Провайдер контекста сообщений
MessagingContext.propTypes = {
    titles: MESSAGING_CONTEXT_TITLES_SHAPE,
    texts: MESSAGING_CONTEXT_TEXTS_SHAPE,
    buttons: MESSAGING_CONTEXT_BUTTONS_SHAPE,
    children: PropTypes.oneOfType([PropTypes.arrayOf(PropTypes.node), PropTypes.node])
};
