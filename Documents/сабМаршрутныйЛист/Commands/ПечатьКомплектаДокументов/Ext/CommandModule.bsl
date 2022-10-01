﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Документ.сабМаршрутныйЛист.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	МассивОбъектовПечати = ПолучитьОбъектыПечати(ПараметрКоманды);
	
	Если МассивОбъектовПечати.Количество() Тогда
		ОткрытьФорму("ОбщаяФорма.НастройкаПечатиКомплекта", Новый Структура("Объекты, МенеджерПечати, ИмяФормы",
			МассивОбъектовПечати, "Документ.РеализацияТоваровУслуг", "Документ.РеализацияТоваровУслуг.Форма.ФормаСписка"));
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю("Нет документов для печати комплекта.");	
	КонецЕсли;
		
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
