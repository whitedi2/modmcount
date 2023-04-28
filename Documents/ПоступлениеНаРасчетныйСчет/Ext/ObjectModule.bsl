﻿
&После("ПередЗаписью")
Процедура УУ_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Модифицированность() Тогда
		сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка, РежимЗаписи);	
	КонецЕсли;	
КонецПроцедуры

&После("ОбработкаПроведения")
Процедура УУ_ОбработкаПроведения(Отказ, РежимПроведения)
	
	Для каждого ТекСтрока Из ЭтотОбъект.РасшифровкаПлатежа Цикл
		Если ЗначениеЗаполнено(ТекСтрока.СчетНаОплату) И ТипЗнч(ТекСтрока.СчетНаОплату) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			
						
			НаборЗаписей = РегистрыСведений.сабГрафикПлатежей.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Документ.Установить(ТекСтрока.СчетНаОплату);
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() Тогда
				
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				|	ЕСТЬNULL(СУММА(ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.СуммаПлатежа), 0) КАК СуммаПлатежа
				|ИЗ
				|	Документ.ПоступлениеНаРасчетныйСчет.РасшифровкаПлатежа КАК ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа
				|ГДЕ
				|	НЕ ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка = &Ссылка
				|	И ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.СчетНаОплату = &СчетНаОплату";
				
				Запрос.УстановитьПараметр("Ссылка", Ссылка);
				Запрос.УстановитьПараметр("СчетНаОплату", ТекСтрока.СчетНаОплату);
				
				Результат = Запрос.Выполнить();
				Выборка = Результат.Выбрать();
				
				СуммаУжеОплачено = 0;
				Пока Выборка.Следующий() Цикл
					СуммаУжеОплачено = Выборка.СуммаПлатежа;			
				КонецЦикла;
				
				ТекСумма = ТекСтрока.СчетНаОплату.СуммаДокумента - ЭтотОбъект.СуммаДокумента - СуммаУжеОплачено;
				Если ТекСумма > 0 Тогда
					Для каждого ТекЗапись Из НаборЗаписей Цикл
						ТекЗапись.Сумма = ТекСумма; 
					КонецЦикла;
				Иначе	
					НаборЗаписей.Очистить();
				КонецЕсли;
				НаборЗаписей.Записать();
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
