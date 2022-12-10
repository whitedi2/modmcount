﻿
&Вместо("ДобавитьЗапись")
Процедура УУ_ДобавитьЗапись(СтруктураЗаписи, Загрузка)
	
	Если СтруктураЗаписи.Свойство("ТипПриемника") Тогда
		Если СтруктураЗаписи.ТипПриемника = "ДокументСсылка.ЗаказКлиента" Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПроверяемыеРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Добавить("УзелИнформационнойБазы");
	ПроверяемыеРеквизиты.Добавить("УникальныйИдентификаторПриемника");
	
	Для Каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
		Если СтруктураЗаписи.Свойство(ПроверяемыйРеквизит)
			И Не ЗначениеЗаполнено(СтруктураЗаписи[ПроверяемыйРеквизит]) Тогда
			
			ОписаниеСобытия = НСтр("ru = 'Добавление записи регистра сведений ""Соответствия объектов информационных баз""'",
			ОбщегоНазначения.КодОсновногоЯзыка());
			Комментарий     = НСтр("ru = 'Не заполнен реквизит %1. Создание записи регистра невозможно.'");
			Комментарий     = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Комментарий, ПроверяемыйРеквизит);
			ЗаписьЖурналаРегистрации(ОписаниеСобытия, 
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.РегистрыСведений.СоответствияОбъектовИнформационныхБаз,
			,
			Комментарий);
			
			Возврат;
			
		КонецЕсли;
	КонецЦикла;
	
	ОбменДаннымиСлужебный.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СоответствияОбъектовИнформационныхБаз", Загрузка);
	
КонецПроцедуры
