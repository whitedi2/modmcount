﻿
&После("ПередЗаписью")
Процедура УУ_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Модифицированность() Тогда
		сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка);	
	КонецЕсли;
	
	//удаляем связаные записи графика платежей
	УстановитьПривилегированныйРежим(Истина);
	Если Проведен Тогда
		Для каждого ТекСтрока Из ЭтотОбъект.РасшифровкаПлатежа Цикл
			Если ЗначениеЗаполнено(ТекСтрока.СчетНаОплату) И ТипЗнч(ТекСтрока.СчетНаОплату) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
				НаборЗаписей = РегистрыСведений.сабГрафикПлатежей.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Документ.Установить(ТекСтрока.СчетНаОплату);
				НаборЗаписей.Прочитать();
				НаборЗаписей.Очистить();
				НаборЗаписей.Записать();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры