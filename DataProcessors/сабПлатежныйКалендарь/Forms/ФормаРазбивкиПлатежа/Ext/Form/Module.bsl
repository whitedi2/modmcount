
&НаКлиенте
Процедура РазбитьПлатеж(Команда)
	
	Если Сумма > СуммаПлатежа Тогда
		сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
		ЭтотОбъект,
		"Сумма превышает сумму платежа " + СуммаПлатежа + ". Платеж не может быть разбит.",
		,		
		,
		"Сумма", 
		Истина);
		Возврат;
	КонецЕсли;
	
	Оповестить("сабРазбитьПлатеж", Новый Структура("Дата, Сумма, КлючЗаписи, ИмяФормыВладельца", Дата, Сумма, КлючЗаписи, ИмяФормыВладельца));
	Закрыть();
	
КонецПроцедуры
