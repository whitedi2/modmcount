﻿&НаСервере
Функция НайтиКонтрагента(Наименование)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Контрагенты.Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Предприятия.Предприятие В(&Предприятие)
	|	И Контрагенты.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		УжеСуществует = Выборка.Ссылка;
	Иначе
		УжеСуществует = Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	Возврат УжеСуществует;
КонецФункции


&НаСервере
Функция НайтиНоменклатуру(Наименование)
	Если ПустаяСтрока(СокрЛП(Наименование)) Тогда
		Возврат "";	
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Номенклатура.Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Предприятие = &Предприятие
	|	И Номенклатура.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		УжеСуществует = Выборка.Ссылка;
	иначе
		ГруппаБюджет = Справочники.Номенклатура.НайтиПоНаименованию("Бюджет", 1);
		НовыйЭлемент = Справочники.Номенклатура.СоздатьЭлемент();
		НовыйЭлемент.Родитель = ГруппаБюджет;
		НовыйЭлемент.Наименование = Наименование;
		НовыйЭлемент.Предприятие = Предприятие;
		НовыйЭлемент.Записать();
		УжеСуществует = НовыйЭлемент.Ссылка;
		//ДобавитьНоменклатуру(Наименование, Предприятие);
		Сообщить("Номенклатуна " + Строка(Наименование) + " создана!");
	КонецЕсли;
	Возврат УжеСуществует;
КонецФункции



&НаСервере
Процедура ЗаполнитьТаблицу()
	ТабличныеЧасти.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Д_БюджетПродажБюджетПродаж.Ссылка,
	|	Д_БюджетПродажБюджетПродаж.НомерСтроки,
	|	Д_БюджетПродажБюджетПродаж.Контрагент,
	|	Д_БюджетПродажБюджетПродаж.Номенклатура,
	|	Д_БюджетПродажБюджетПродаж.Покупной,
	|	Д_БюджетПродажБюджетПродаж.ЦенаЗакупки,
	|	Д_БюджетПродажБюджетПродаж.ДЗНачало,
	|	Д_БюджетПродажБюджетПродаж.Количество,
	|	Д_БюджетПродажБюджетПродаж.Цена,
	|	Д_БюджетПродажБюджетПродаж.ПоступлениеДС,
	|	Д_БюджетПродажБюджетПродаж.Ссылка.Дата,
	|	Д_БюджетПродажБюджетПродаж.Ссылка.Предприятие
	|ИЗ
	|	Документ.Д_БюджетПродаж.БюджетПродаж КАК Д_БюджетПродажБюджетПродаж
	|ГДЕ
	|	Д_БюджетПродажБюджетПродаж.Ссылка.Сценарий = &Сценарий
	|	И Д_БюджетПродажБюджетПродаж.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И Д_БюджетПродажБюджетПродаж.Ссылка.Предприятие = &Предприятие";
	
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТабличныеЧасти.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);	 
	КонецЦикла;
	
	
	
	
	
КонецПроцедуры



&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	ЗаполнитьТаблицу();
КонецПроцедуры


&НаСервере
Функция ВернутьДокумент(ТекДата, Сценарий, Предприятие)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Д_БюджетПродаж.Ссылка
	|ИЗ
	|	Документ.Д_БюджетПродаж КАК Д_БюджетПродаж
	|ГДЕ
	|	Д_БюджетПродаж.ПометкаУдаления = ЛОЖЬ
	|	И Д_БюджетПродаж.Дата = &Дата
	|	И Д_БюджетПродаж.Сценарий = &Сценарий
	|	И Д_БюджетПродаж.Предприятие = &Предприятие";
	
	Запрос.УстановитьПараметр("Дата", ТекДата);
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Документы.Д_БюджетПродаж.ПустаяСсылка();
	КонецЕсли;
	
	
	
	
КонецФункции // ()


&НаСервере
Процедура ЗаписатьДокументы()
	//Документы.Д_БюджетПродаж.ПустаяСсылка().БюджетПродаж.
	
	
	НоваяТЧ = ТабличныеЧасти.Выгрузить();
	НоваяТЧ.Свернуть("Дата, Предприятие");
	
	Для каждого ТекСтрока Из НоваяТЧ Цикл
		СтруктураПоиска = Новый Структура("Дата, Предприятие", ТекСтрока.Дата, ТекСтрока.Предприятие) ;
		МассивОтбора = ТабличныеЧасти.НайтиСтроки(СтруктураПоиска);
		Если МассивОтбора.Количество() Тогда
			Если ПустаяСтрока(МассивОтбора[0].Ссылка) Тогда
				ТекДокумент = ВернутьДокумент(ТекСтрока.Дата, Сценарий, ТекСтрока.Предприятие);
				Если ПустаяСтрока(ТекДокумент) Тогда
					Сообщить("Документ на " + Строка(ТекСтрока.Дата) + " по сценарию " + Строка(Сценарий) + " не найден.");
					Продолжить;			
				КонецЕсли;
			Иначе
				ТекДокумент = МассивОтбора[0].Ссылка;
			КонецЕсли;
			ТекДокументОбъект = ТекДокумент.ПолучитьОбъект();
			ТекДокументОбъект.БюджетПродаж.Очистить();
			Для каждого ТекСтрокаОтбора Из МассивОтбора Цикл
				ТекСтрокаОтбора.Ссылка = ТекДокумент;
				НовСтрокаДока = ТекДокументОбъект.БюджетПродаж.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрокаДока, ТекСтрокаОтбора);	 				
				
			КонецЦикла;
			ТекДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли;
	КонецЦикла; 
	
	
КонецПроцедуры


&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьДокументы();
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьТаблицу();
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	ПутьКФайлу = БюджетныйНаКлиенте.ВыбратьФайлExcel();	
	Если НЕ ПутьКФайлу = Неопределено Тогда
		Док = ПолучитьCOMОбъект(ПутьКФайлу);
		КоличествоСтраниц = 1;
		
		Для ТекНомер = 1 По КоличествоСтраниц Цикл
			счСтроки = 2;
			Пока СокрЛП(Док.Sheets(ТекНомер).Cells(счСтроки,1).Value) <> "" Цикл	
				
				ТекПредприятие = Строка(Док.Sheets(ТекНомер).Cells(счСтроки,2).Value);
				ТекДата = СокрЛП(Док.Sheets(ТекНомер).Cells(счСтроки,1).Value);
				
				Если НЕ ТекПредприятие = Строка(Предприятие) Тогда
					Продолжить;				
				КонецЕсли;
				
				Контрагент = НайтиКонтрагента(Строка(Док.Sheets(ТекНомер).Cells(счСтроки,4).Value));
				Номенклатура = НайтиНоменклатуру(Док.Sheets(ТекНомер).Cells(счСтроки,3).Value);
				
				Если ПустаяСтрока(Контрагент) Тогда
					Сообщить("Контрагент " + Строка(Док.Sheets(ТекНомер).Cells(счСтроки,4).Value) + " не найден.");
				КонецЕсли;
				
				Если ПустаяСтрока(Номенклатура) Тогда
					Сообщить("Номенклатура " + Строка(Док.Sheets(ТекНомер).Cells(счСтроки,3).Value) + " не найдена");
				КонецЕсли;
				
				
				
				
				
				//добавляем запись в табличную часть
				НоваяСтрока = ТабличныеЧасти.Добавить();
				НоваяСтрока.Контрагент = Контрагент;
				НоваяСтрока.Предприятие = Предприятие;
				НоваяСтрока.Дата = ТекДата;
				НоваяСтрока.Номенклатура = Номенклатура;
				НоваяСтрока.ДЗНачало = Док.Sheets(ТекНомер).Cells(счСтроки,6).Value;
				НоваяСтрока.Количество = Док.Sheets(ТекНомер).Cells(счСтроки,5).Value;
				НоваяСтрока.Цена = Док.Sheets(ТекНомер).Cells(счСтроки,7).Value;
				//НоваяСтрока.ЖДАвто = ?(СокрЛП(Строка(Док.Sheets(ТекНомер).Cells(счСтроки,12).Value)) = "", 0, 
				//	Док.Sheets(ТекНомер).Cells(счСтроки,12).Value)	
				//	+ ?(СокрЛП(Строка(Док.Sheets(ТекНомер).Cells(счСтроки,13).Value)) = "", 0,
				//	Док.Sheets(ТекНомер).Cells(счСтроки,13).Value);
				//НоваяСтрока.ВозмещениеТр = Док.Sheets(ТекНомер).Cells(счСтроки,16).Value;	
				//НоваяСтрока.ВозмещениеТр = ?(НоваяСтрока.Количество, НоваяСтрока.ВозмещениеТр / НоваяСтрока.Количество, 0);
				//НоваяСтрока.Предоплата = Док.Sheets(ТекНомер).Cells(счСтроки,20).Value;
				//НоваяСтрока.Отсрочка = Док.Sheets(ТекНомер).Cells(счСтроки,21).Value;
				НоваяСтрока.ПоступлениеДС = Док.Sheets(ТекНомер).Cells(счСтроки,13).Value;
				//НоваяСтрока.КЗНачало = Док.Sheets(ТекНомер).Cells(счСтроки,26).Value;
				НоваяСтрока.ЦенаЗакупки = Док.Sheets(ТекНомер).Cells(счСтроки,8).Value;
				//НоваяСтрока.Верх = Док.Sheets(ТекНомер).Cells(счСтроки,9).Value;
				
				счСтроки = счСтроки + 1;
			КонецЦикла;
			
		КонецЦикла;	
		
		//Док.Application.Quit();
		Сообщить("Загрузка успешно выполнена.");
	КонецЕсли;
КонецПроцедуры
