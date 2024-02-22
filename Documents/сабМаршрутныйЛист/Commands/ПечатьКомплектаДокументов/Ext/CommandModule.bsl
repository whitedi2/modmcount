﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Документ.сабМаршрутныйЛист.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	//УстановитьПривилегированныйРежимПользователю(Истина);

	МассивОбъектовПечати = ПолучитьОбъектыПечати(ПараметрКоманды);

	ДокументыИсточника = Новый СписокЗначений;
	ДокументыИсточника.ЗагрузитьЗначения(ПараметрКоманды);
	
	Если МассивОбъектовПечати.Количество() Тогда
		ОткрытьФорму("ОбщаяФорма.сабНастройкаПечатиКомплекта", Новый Структура("Объекты, МенеджерПечати, ИмяФормы, ДокументыИсточника",
			МассивОбъектовПечати, "Документ.РеализацияТоваровУслуг", "Документ.РеализацияТоваровУслуг.Форма.ФормаСписка", ДокументыИсточника));
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю("Нет документов для печати комплекта.");	
	КонецЕсли; 
	
	
	//БюджетныйНаКлиенте.УниверсальноеВыполнениеКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды);
	//УстановитьПривилегированныйРежимПользователю(Ложь);
		
КонецПроцедуры

&НаСервере
Функция ПолучитьОбъектыПечати(ПараметрКоманды)

	МассивОбъектовПечати = Новый Массив;
	
	Для Каждого ТекЭлемент Из ПараметрКоманды Цикл
		
		Для Каждого ТекСтрокаТЧ Из ТекЭлемент.ТабличнаяЧасть Цикл 
			МассивОбъектовПечати.Добавить(ТекСтрокаТЧ.Реализация);			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат МассивОбъектовПечати;
	
КонецФункции

&НаСервере
Процедура УстановитьПривилегированныйРежимПользователю(ЗначениеПар) 
	Если РольДоступна("сабКладовщик") ИЛИ РольДоступна("сабОперационист") или РольДоступна("полныеПрава") тогда
		УстановитьПривилегированныйРежим(ЗначениеПар);
	КонецЕсли;
КонецПроцедуры
