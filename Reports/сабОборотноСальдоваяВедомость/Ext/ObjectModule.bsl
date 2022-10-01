﻿Перем НаборПоказателей Экспорт;
Перем ВысотаШапки;
Перем ВременныеДанныеОтчета;

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки,
							|ИспользоватьПередВыводомЭлементаРезультата",
							Истина, Истина, Истина, Истина, Истина);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина, ОбъектОтчет) Экспорт 
	
	ЭквВалюта = ?(ЗначениеЗаполнено(ОбъектОтчет.ЭквивалентнаяВалюта), ОбъектОтчет.ЭквивалентнаяВалюта, УЧ_Сервер.НациональнаяВалюта());

	Возврат "Оборотно-сальдовая ведомость" + СтандартныеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ОбъектОтчет.НачалоПериода, ОбъектОтчет.КонецПериода) + "
	|Валюта: " + ЭквВалюта;
	
КонецФункции

Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, Схема = Неопределено, ВыводитьПолностью = Истина) Экспорт
	
	УправленческийУчетПовтИсп.ВывестиОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, Схема, ВыводитьПолностью); 
	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(Схема, ОбъектОтчет) Экспорт
	
	//Если ТипЗнч(ОбъектОтчет) = Тип("Структура") Тогда
	//	ТекНастройки = ОбъектОтчет.КомпоновщикНастроек;
	//	КомпоновщикНастроекПроизвольный = Новый КомпоновщикНастроекКомпоновкиДанных;
	//	КомпоновщикНастроекПроизвольный.ЗагрузитьНастройки(ТекНастройки);
	//Иначе	
		КомпоновщикНастроекПроизвольный = ОбъектОтчет.КомпоновщикНастроек;	
	//КонецЕсли; 
	
	КомпоновщикНастроекПроизвольный.Настройки.Структура.Очистить();
	КомпоновщикНастроекПроизвольный.Настройки.Выбор.Элементы.Очистить();
			
	КоличествоПоказателей = УправленческийУчетПовтИсп.КоличествоПоказателей(ОбъектОтчет);
	
	Если КоличествоПоказателей > 1 Тогда
		ГруппаПоказатели = КомпоновщикНастроекПроизвольный.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок     = "Показатели";
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из ОбъектОтчет.НаборПоказателей Цикл
			Если ОбъектОтчет["Показатель" + ?(ТипЗнч(ИмяПоказателя) = Тип("КлючИЗначение"), ИмяПоказателя.Ключ,ИмяПоказателя)] Тогда 
				СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ?(ТипЗнч(ИмяПоказателя) = Тип("КлючИЗначение"), ИмяПоказателя.Ключ,ИмяПоказателя));
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
		
	ГруппаСальдоНаНачало = КомпоновщикНастроекПроизвольный.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачало.Заголовок     = "Сальдо на начало периода";
	ГруппаСальдоНаНачало.Использование = Истина;
	ГруппаСальдоНаНачалоДт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоДт.Заголовок     = "Дебет";
	ГруппаСальдоНаНачалоДт.Использование = Истина;
	ГруппаСальдоНаНачалоДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаНачалоКт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоКт.Заголовок     = "Кредит";
	ГруппаСальдоНаНачалоКт.Использование = Истина;
	ГруппаСальдоНаНачалоКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаОбороты = КомпоновщикНастроекПроизвольный.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОбороты.Заголовок     = "Обороты за период";
	ГруппаОбороты.Использование = Истина;
	ГруппаОборотыДт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыДт.Заголовок     = "Дебет";
	ГруппаОборотыДт.Использование = Истина;
	ГруппаОборотыДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаОборотыКт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыКт.Заголовок     = "Кредит";
	ГруппаОборотыКт.Использование = Истина;
	ГруппаОборотыКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаСальдоНаКонец = КомпоновщикНастроекПроизвольный.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонец.Заголовок     = "Сальдо на конец периода";
	ГруппаСальдоНаКонец.Использование = Истина;
	ГруппаСальдоНаКонецДт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецДт.Заголовок     = "Дебет";
	ГруппаСальдоНаКонецДт.Использование = Истина;
	ГруппаСальдоНаКонецДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаКонецКт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецКт.Заголовок     = "Кредит";
	ГруппаСальдоНаКонецКт.Использование = Истина;
	ГруппаСальдоНаКонецКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	  
	ВидОстатков = "";
	
	Для Каждого ИмяПоказателя Из ОбъектОтчет.НаборПоказателей Цикл
		ИмяПоказателя = ?(ТипЗнч(ИмяПоказателя) = Тип("КлючИЗначение"), ИмяПоказателя.Ключ, ИмяПоказателя);
		Если ОбъектОтчет["Показатель" + ИмяПоказателя] Тогда 
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатков + "ОстатокДт");
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатков + "ОстатокКт");
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыДт,        "ОборотыЗаПериод."       + ИмяПоказателя + ВидОстатков + "ОборотДт");
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыКт,        "ОборотыЗаПериод."       + ИмяПоказателя + ВидОстатков + "ОборотКт");
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "Конечный"  + ВидОстатков + "ОстатокДт");
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "Конечный"  + ВидОстатков + "ОстатокКт");
		КонецЕсли;
	КонецЦикла;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("Контроль");
	МассивПоказателей.Добавить("ВалютнаяСумма");
	
	Для Каждого ИмяПоказателя Из ОбъектОтчет.НаборПоказателей Цикл
		ИмяПоказателя = ?(ТипЗнч(ИмяПоказателя) = Тип("КлючИЗначение"), ИмяПоказателя.Ключ, ИмяПоказателя);
		Если ОбъектОтчет["Показатель" + ИмяПоказателя] Тогда
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокДт");
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокКт");
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыДт,        "ОборотыЗаПериод."       + ИмяПоказателя + "ОборотДт");
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыКт,        "ОборотыЗаПериод."       + ИмяПоказателя + "ОборотКт");
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "КонечныйОстатокДт");
			СтандартныеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "КонечныйОстатокКт");
		КонецЕсли;
	КонецЦикла;
  	
	Схема = Отчеты.сабОборотноСальдоваяВедомость.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	// Доработка схемы - развернутое сальдо
	НаборДанных = Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.ПоСубконтоРазвернутое; // Набор "ПоСубконтоРазвернутое"
	ТекстЗапроса = НаборДанных.Запрос;
	НаборДанных.Запрос = "";
	
	ТекстЗапросПоСубконтоРазвернутое       = УправленческийУчетПовтИсп.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало ЗапросПоСубконто РазвернутоеСальдо", "//Конец ЗапросПоСубконто РазвернутоеСальдо");
	ТекстУсловиеСчетаПоСубконтоРазвернутое = УправленческийУчетПовтИсп.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало УсловиеСчета РазвернутоеСальдо"    , "//Конец УсловиеСчета РазвернутоеСальдо");
	ТекстСубконтоПоСубконтоРазвернутое     = УправленческийУчетПовтИсп.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало Субконто РазвернутоеСальдо"        , "//Конец Субконто РазвернутоеСальдо");
		
	ВыводитьРазвернутоеСальдо = Ложь;
	
	ТекстУсловие = "Ложь ИЛИ ";
	
	СписокВсехСчетовРазвернутоеСальдо = Новый СписокЗначений;
	Для Каждого СтрокаТаблицы Из ОбъектОтчет.РазвернутоеСальдо Цикл
		Если СтрокаТаблицы.Использование И ЗначениеЗаполнено(СтрокаТаблицы.Счет) Тогда
			СписокВсехСчетовРазвернутоеСальдо.Добавить(СтрокаТаблицы.Счет);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из ОбъектОтчет.РазвернутоеСальдо Цикл
		СубконтоРазвернутоеСальдо = Новый СписокЗначений;
		Если СтрокаТаблицы.Использование И ЗначениеЗаполнено(СтрокаТаблицы.Счет) Тогда
			ВыводитьРазвернутоеСальдо = Истина;
			
			ДанныеСчета = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.Счет);
			СписокВидовСубконто = Новый СписокЗначений;
			КоличествоСубконто = СтрДлина(СтрокаТаблицы.ПоСубконто) / 2;
			Для Индекс = 1 По КоличествоСубконто Цикл
				СписокВидовСубконто.Добавить(ДанныеСчета["ВидСубконто" + Сред(СтрокаТаблицы.ПоСубконто, Индекс*2, 1)], ДанныеСчета["ВидСубконто" + Сред(СтрокаТаблицы.ПоСубконто, Индекс*2, 1) + "Наименование"], ?(Сред(СтрокаТаблицы.ПоСубконто, Индекс * 2 - 1, 1) = "+", Истина, Ложь));
			КонецЦикла;
			
			Для Каждого СтрокаТаблицыСубконто Из СписокВидовСубконто Цикл
				Если СтрокаТаблицыСубконто.Пометка Тогда
					СубконтоРазвернутоеСальдо.Добавить(СтрокаТаблицыСубконто.Значение);            
				КонецЕсли;
			КонецЦикла;		
			
			//СписокСчетовРазвернутоеСальдо.Добавить(Строка.Счет, , Истина);
			
			Индекс = ОбъектОтчет.РазвернутоеСальдо.Индекс(СтрокаТаблицы) + 1;
			
			ТекстУсловие = ТекстУсловие + "Счет = &СчетРазвернутоеСальдо" + Индекс + " ИЛИ "; 
			
			// Формируем текст параметра УсловиеСчета запроса детализации по субконто
			ТекстДляПодстановкиУсловиеСчетаПоСубконтоРазвернутое = "Счет В ИЕРАРХИИ (&СчетРазвернутоеСальдо" + Индекс + ")
																	| И Счет НЕ В (&СчетаИсключенныеИзЗапросаПоСчетамРазвернутое" + Индекс + ")
																	| И ((НЕ Счет.Забалансовый)
																	| ИЛИ &ВыводитьЗабалансовыеСчета)";
			
			// Формируем текст параметра Субконто запроса по субконто развернутое
			ТекстДляПодстановкиСубконтоПоСубконтоРазвернутое = "&СубконтоРазвернутый" + Индекс;
			
			// Установка параметра СчетРазвернутоеСальдо
			УправленческийУчетПовтИсп.СкопироватьПараметрСхемыКомпоновкиДанных(Схема, "СчетРазвернутоеСальдо" + Индекс, "СчетРазвернутоеСальдо", СтрокаТаблицы.Счет);
			
			СчетаИсключенныеИзЗапросаПоСчетамРазвернутое = СписокВсехСчетовРазвернутоеСальдо.Скопировать();
			СчетаИсключенныеИзЗапросаПоСчетамРазвернутое.Удалить(СчетаИсключенныеИзЗапросаПоСчетамРазвернутое.НайтиПоЗначению(СтрокаТаблицы.Счет));
			// Установка параметра СчетаИсключенныеИзЗапросаПоСчетамРазвернутое
			УправленческийУчетПовтИсп.СкопироватьПараметрСхемыКомпоновкиДанных(Схема, "СчетаИсключенныеИзЗапросаПоСчетамРазвернутое" + Индекс, "СчетаИсключенныеИзЗапросаПоСчетамРазвернутое", СчетаИсключенныеИзЗапросаПоСчетамРазвернутое);
			
			// Установка параметра "СубконтоДетализацииРазвернутый
			УправленческийУчетПовтИсп.СкопироватьПараметрСхемыКомпоновкиДанных(Схема, "СубконтоРазвернутый" + Индекс, "СубконтоРазвернутый", СубконтоРазвернутоеСальдо);
			
			// Формируем текст запроса для счета детализации
			ТекстДляПодстановкиЗапросПоСубконтоРазвернутое = ТекстЗапросПоСубконтоРазвернутое;//СтрЗаменить(ТекстЗапросПоСубконтоРазвернутое, ТекстПолеСчетПоСубконтоРазвернутое, ТекстДляПодстановкиПолеСчетПоСубконтоРазвернутое);
			ТекстДляПодстановкиЗапросПоСубконтоРазвернутое = СтрЗаменить(ТекстДляПодстановкиЗапросПоСубконтоРазвернутое, ТекстУсловиеСчетаПоСубконтоРазвернутое, ТекстДляПодстановкиУсловиеСчетаПоСубконтоРазвернутое);
			ТекстДляПодстановкиЗапросПоСубконтоРазвернутое = СтрЗаменить(ТекстДляПодстановкиЗапросПоСубконтоРазвернутое, ТекстСубконтоПоСубконтоРазвернутое, ТекстДляПодстановкиСубконтоПоСубконтоРазвернутое);
			
			Для Индекс = 1 По СубконтоРазвернутоеСальдо.Количество() Цикл
				ТекстДляПодстановкиЗапросПоСубконтоРазвернутое = СтрЗаменить(ТекстДляПодстановкиЗапросПоСубконтоРазвернутое, "Null КАК ВложСубконто" + Индекс, "ОстаткиИОбороты.Субконто" + Индекс + " КАК Субконто" + Индекс);
				ТекстДляПодстановкиЗапросПоСубконтоРазвернутое = СтрЗаменить(ТекстДляПодстановкиЗапросПоСубконтоРазвернутое, "Null КАК Субконто" + Индекс, "ВложенныйЗапрос.Субконто" + Индекс + " КАК Субконто" + Индекс);
			КонецЦикла;
			
			// Доработка запроса набора данных
			НаборДанных.Запрос = НаборДанных.Запрос + ТекстДляПодстановкиЗапросПоСубконтоРазвернутое;
			
			// Доработка запроса набора данных
			НаборДанных.Запрос = НаборДанных.Запрос + " ОБЪЕДИНИТЬ ВСЕ ";
		КонецЕсли;	
	КонецЦикла;
	НаборДанных.Запрос = Лев(НаборДанных.Запрос, СтрДлина(НаборДанных.Запрос) - 16);
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	//МассивПоказателей.Добавить("НУ");
	//МассивПоказателей.Добавить("ПР");
	//МассивПоказателей.Добавить("ВР");
	
	Если ВыводитьРазвернутоеСальдо Тогда
		ТекстУсловие = Лев(ТекстУсловие, СтрДлина(ТекстУсловие) - 4);
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			ПолеИтога = Схема.ПоляИтога.Найти("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокДт");
			ПолеИтога.Выражение = "Выбор Когда " + ТекстУсловие + " Тогда Сумма(СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйРазвернутыйОстатокДт) Иначе Сумма(СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокДт) Конец";
			
			ПолеИтога = Схема.ПоляИтога.Найти("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокКт");
			ПолеИтога.Выражение = "Выбор Когда " + ТекстУсловие + " Тогда Сумма(СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйРазвернутыйОстатокКт) Иначе Сумма(СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокКт) Конец";
			
			ПолеИтога = Схема.ПоляИтога.Найти("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокДт");
			ПолеИтога.Выражение = "Выбор Когда " + ТекстУсловие + " Тогда Сумма(СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйРазвернутыйОстатокДт) Иначе Сумма(СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокДт) Конец";
			
			ПолеИтога = Схема.ПоляИтога.Найти("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокКт");
			ПолеИтога.Выражение = "Выбор Когда " + ТекстУсловие + " Тогда Сумма(СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйРазвернутыйОстатокКт) Иначе Сумма(СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокКт) Конец";
		КонецЦикла;
	КонецЕсли;
	
	НаборДанных = Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.ПоСубконто; // Набор "ПоСубконто"
	ТекстЗапроса = НаборДанных.Запрос;
	НаборДанных.Запрос = "";
	
	ТекстЗапросДетализацииПоСубконто       = УправленческийУчетПовтИсп.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало ЗапросПоСубконто Детализация", "//Конец ЗапросПоСубконто Детализация");
	ТекстУсловиеСчетаДетализацииПоСубконто = УправленческийУчетПовтИсп.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало УсловиеСчета Детализация", "//Конец УсловиеСчета Детализация");
	ТекстСубконтоДетализацииПоСубконто     = УправленческийУчетПовтИсп.ПолучитьТекстПоМаркерам(ТекстЗапроса, "//Начало Субконто Детализация", "//Конец Субконто Детализация");
	
	СчетаИсключенныеИзЗапросаПоСчетам = Новый СписокЗначений;
	
	// Доработка для детализации
	ЕстьДетализацияПоСубконто = Ложь;
	Для Каждого СтрокаТаблицы Из ОбъектОтчет.Группировка Цикл	
		СубконтоДетализации = Новый СписокЗначений;
		Если СтрокаТаблицы.Использование И ЗначениеЗаполнено(СтрокаТаблицы.Счет) Тогда	
			ДанныеСчета = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.Счет);
			СписокВидовСубконто = Новый СписокЗначений;
			КоличествоСубконто = СтрДлина(СтрокаТаблицы.ПоСубконто) / 2;
			Для Индекс = 1 По КоличествоСубконто Цикл
				СписокВидовСубконто.Добавить(ДанныеСчета["ВидСубконто" + Сред(СтрокаТаблицы.ПоСубконто, Индекс*2, 1)], ДанныеСчета["ВидСубконто" + Сред(СтрокаТаблицы.ПоСубконто, Индекс*2, 1) + "Наименование"], ?(Сред(СтрокаТаблицы.ПоСубконто, Индекс * 2 - 1, 1) = "+", Истина, Ложь));
			КонецЦикла;
			
			Для Каждого СтрокаТаблицыСубконто Из СписокВидовСубконто Цикл
				Если СтрокаТаблицыСубконто.Пометка Тогда
					СубконтоДетализации.Добавить(СтрокаТаблицыСубконто.Значение);            
				КонецЕсли;
			КонецЦикла;		
		КонецЕсли;
		
		Если СубконтоДетализации.Количество() > 0 Тогда
			ЕстьДетализацияПоСубконто = Истина;
			
			СчетаИсключенныеИзЗапросаПоСчетам.Добавить(СтрокаТаблицы.Счет);
			Индекс = ОбъектОтчет.Группировка.Индекс(СтрокаТаблицы) + 1;
			
			// Формируем текст параметра УсловиеСчета запроса детализации по субконто
			ТекстДляПодстановкиУсловиеСчетаДетализацииПоСубконто = "Счет В ИЕРАРХИИ (&СчетДетализации" + Индекс + ")
																   | И ((НЕ Счет.Забалансовый)
																   | ИЛИ &ВыводитьЗабалансовыеСчета)";
											  
			// Формируем текст параметра Субконто запроса детализации по субконто
			ТекстДляПодстановкиСубконтоДетализацииПоСубконто = "&СубконтоДетализации" + Индекс;
			
			// Формируем текст запроса для счета детализации
			ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстЗапросДетализацииПоСубконто, ТекстУсловиеСчетаДетализацииПоСубконто, ТекстДляПодстановкиУсловиеСчетаДетализацииПоСубконто);
			ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстДляПодстановкиЗапросДетализацииПоСубконто, ТекстСубконтоДетализацииПоСубконто, ТекстДляПодстановкиСубконтоДетализацииПоСубконто);
			
			// Корректировка текста запроса в зависимости от количества указанных видов субконто
			Если Индекс > 1 Тогда
				Для ИндексПсевдонима = 1 По 3 Цикл
					ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстДляПодстановкиЗапросДетализацииПоСубконто, " КАК Субконто" + ИндексПсевдонима, "");
				КонецЦикла;
			КонецЕсли;
			Для ИндексСубконто = СубконтоДетализации.Количество() + 1 По 3 Цикл
				ТекстДляПодстановкиЗапросДетализацииПоСубконто = СтрЗаменить(ТекстДляПодстановкиЗапросДетализацииПоСубконто, "ОстаткиИОбороты.Субконто" + ИндексСубконто , "Null");	
			КонецЦикла;
			
			// Добавление и установка значения параметра СчетДетализации{Индекс}
			
			УправленческийУчетПовтИсп.СкопироватьПараметрСхемыКомпоновкиДанных(Схема, "СчетДетализации" + Индекс, "СчетДетализации", СтрокаТаблицы.Счет);
			
			// Добавление и установка значения параметра СубконтоДетализации{Индекс}
			УправленческийУчетПовтИсп.СкопироватьПараметрСхемыКомпоновкиДанных(Схема, "СубконтоДетализации" + Индекс, "СубконтоДетализации", СубконтоДетализации);
							
			// Доработка запроса набора данных
			НаборДанных.Запрос = НаборДанных.Запрос + ТекстДляПодстановкиЗапросДетализацииПоСубконто;
			
			// Доработка запроса набора данных
			НаборДанных.Запрос = НаборДанных.Запрос + " ОБЪЕДИНИТЬ ВСЕ ";	
		КонецЕсли;
	КонецЦикла;
	
	НаборДанных.Запрос = Лев(НаборДанных.Запрос, СтрДлина(НаборДанных.Запрос) - 16);
	
	Схема.Параметры.ВыводитьЗабалансовыеСчета.Значение = Истина;
	
	Схема.Параметры.СчетаИсключенныеИзЗапросаПоСчетам.Значение = СчетаИсключенныеИзЗапросаПоСчетам;
	
	Если Не ЕстьДетализацияПоСубконто Тогда
		Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.Удалить(Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.ПоСубконто);
	КонецЕсли;
	Если Не ВыводитьРазвернутоеСальдо Тогда
		Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.Удалить(Схема.НаборыДанных.НаборДанныхОбъединение.Элементы.ПоСубконтоРазвернутое);
	КонецЕсли;
		
	КомпоновщикНастроекПроизвольный.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
	
	Для Каждого Параметр Из КомпоновщикНастроекПроизвольный.Настройки.ПараметрыДанных.Элементы Цикл
		Параметр.Использование = Истина;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроекПроизвольный, "СчетаИсключенныеИзЗапросаПоСчетам", СчетаИсключенныеИзЗапросаПоСчетам);
	
	Если ЗначениеЗаполнено(ОбъектОтчет.НачалоПериода) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроекПроизвольный, "НачалоПериода", НачалоДня(ОбъектОтчет.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ОбъектОтчет.КонецПериода) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроекПроизвольный, "КонецПериода", КонецДня(ОбъектОтчет.КонецПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ОбъектОтчет.Подразделение) Тогда
		СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроекПроизвольный, "Подразделение", ОбъектОтчет.Подразделение,,, Истина);
	КонецЕсли;
	
	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроекПроизвольный, "ЭквивалентнаяВалюта", ?(ЗначениеЗаполнено(ОбъектОтчет.ЭквивалентнаяВалюта), ОбъектОтчет.ЭквивалентнаяВалюта, УЧ_Сервер.НациональнаяВалюта()));
	ДатаКон = ?(ЗначениеЗаполнено(ОбъектОтчет.КонецПериода), ОбъектОтчет.КонецПериода, ТекущаяДата());
	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроекПроизвольный, "ДатаКурса", ДатаКон);
	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроекПроизвольный, "ВыводитьЗабалансовыеСчета", ОбъектОтчет.ВыводитьЗабалансовыеСчета);
	
	// Дополнительные данные
	//наименование к счету
	НайденныеДопПоляНаименоваиня = ОбъектОтчет.ДополнительныеПоля.НайтиСтроки(Новый Структура("Поле", "Счет.Наименование"));
	Если НЕ НайденныеДопПоляНаименоваиня.Количество() Тогда
		НоваяСтрока = ОбъектОтчет.ДополнительныеПоля.Добавить();
		НоваяСтрока.Поле = "Счет.Наименование";
		НоваяСтрока.Использование = Истина;
		ОбъектОтчет.РазмещениеДополнительныхПолей = 1;
	Иначе
		НайденныеДопПоляНаименоваиня[0].Использование = Истина;
		ОбъектОтчет.РазмещениеДополнительныхПолей = 1;
	КонецЕсли;
	
	УправленческийУчетПовтИсп.ДобавитьДополнительныеПоля(ОбъектОтчет);
	
	// Формирование структуры отчета
	Структура = КомпоновщикНастроекПроизвольный.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	
	ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Счет");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	
	//ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	//ПолеГруппировки.Использование  = Истина;
	//ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Наим");
	//ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
	// Установка отбора на выводимый уровень иерархии счета
	ГруппаЭлементовОтбора = Структура.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
	ГруппаЭлементовОтбора.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаЭлементовОтбора, "ПараметрыДанных.ПоСубсчетам", Истина);
	СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаЭлементовОтбора, "СистемныеПоля.УровеньВГруппировке", 1);
	СписокСчетовПоСубсчетам = УправленческийУчетПовтИсп.ПолучитьСписокСчетовПоСубсчетам(ОбъектОтчет.Группировка);
	СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаЭлементовОтбора, "Счет", СписокСчетовПоСубсчетам, ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии, СписокСчетовПоСубсчетам.Количество() > 0);

	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроекПроизвольный, "ПоСубсчетам", ОбъектОтчет.ПоСубсчетам);
	
	// Отключим вывод отборов
	СтандартныеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	
	Если ОбъектОтчет.ПоказательВалютнаяСумма Тогда
		Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));		
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Валюта");
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));	
	КонецЕсли;
	
	Если ЕстьДетализацияПоСубконто Тогда
		Для Индекс = 1 По 3 Цикл 
			Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Субконто" + Индекс);
			ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			Если ОбъектОтчет.ПоказательВалютнаяСумма Тогда
				Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));		
				ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ПолеГруппировки.Использование  = Истина;
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Валюта");
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
				
				Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
				Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	УправленческийУчетПовтИсп.ДобавитьОтборПоОрганизации(ОбъектОтчет);
	УправленческийУчетПовтИсп.ДобавитьОтборДляПоказателяКонтроль(ОбъектОтчет);
	
	УсловноеОформление = КомпоновщикНастроекПроизвольный.Настройки.УсловноеОформление.Элементы.Добавить();
	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода.НУНачальныйОстатокДт");
	//Поле = УсловноеОформление.Поля.Элементы.Добавить();
	//Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода.ПРНачальныйОстатокДт");
	//Поле = УсловноеОформление.Поля.Элементы.Добавить();
	//Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода.ВРНачальныйОстатокДт");
	//Поле = УсловноеОформление.Поля.Элементы.Добавить();
	//Поле.Поле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода.КонтрольНачальныйОстатокДт");
	
	//СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "Счет.НалоговыйУчет", Ложь);
	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
	Если ТипЗнч(ОбъектОтчет) = Тип("Структура") Тогда
		ОбъектОтчет.КомпоновщикНастроек = КомпоновщикНастроекПроизвольный;
	КонецЕсли; 	

	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(МакетКомпоновки, ОбъектОтчет) Экспорт
		
	МакетШапкиОтчета = УправленческийУчетПовтИсп.ПолучитьМакетШапки(МакетКомпоновки);
	
	КоличествоПоказателей = УправленческийУчетПовтИсп.КоличествоПоказателей(ОбъектОтчет);
	
	КоличествоГруппировок = 0;
	Для Каждого СтрокаТаблицы Из ОбъектОтчет.Группировка Цикл
		Если СтрокаТаблицы.Использование Тогда
			КоличествоСубконто = СтрЧислоВхождений(СтрокаТаблицы.ПоСубконто, "+");
			КоличествоГруппировок = Макс(КоличествоГруппировок, КоличествоСубконто);
		КонецЕсли;
	КонецЦикла;
	КоличествоГруппировок = КоличествоГруппировок + 1;

	КоличествоСтрокШапки = Макс(КоличествоГруппировок, 2);
	ВысотаШапки = КоличествоСтрокШапки;
	
	Если ТипЗнч(ОбъектОтчет) = Тип("Структура") Тогда
		ОбъектОтчет.Вставить("ВысотаШапки", ВысотаШапки);
	КонецЕсли;
	
	МассивДляУдаления = Новый Массив;
	Для Индекс = КоличествоСтрокШапки По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
		МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
	КонецЦикла;
	
	КоличествоСтрок = МакетШапкиОтчета.Макет.Количество();
	Для ИндексСтроки = 2 По КоличествоСтрок - 1 Цикл
		СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
		
		КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
		
		Для ИндексКолонки = КоличествоКолонок - 6 По КоличествоКолонок - 1 Цикл
			Ячейка = СтрокаМакета.Ячейки[ИндексКолонки];
			СтандартныеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЦикла;
	
	Если КоличествоПоказателей > 1 Тогда
		Для ИндексСтроки = 1 По КоличествоСтрок - 1 Цикл
			СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
			
			КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
			Ячейка = СтрокаМакета.Ячейки[КоличествоКолонок - 7];
			СтандартныеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
		КонецЦикла;
	КонецЕсли;	
	
	МакетПодвалаОтчета            = УправленческийУчетПовтИсп.ПолучитьМакетПодвала(МакетКомпоновки);
	МакетГруппировкиОрганизация   = УправленческийУчетПовтИсп.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Организация");
	МакетГруппировкиСчет          = УправленческийУчетПовтИсп.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Счет");
	МакетГруппировкиПодразделение = УправленческийУчетПовтИсп.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Подразделение");
	МакетГруппировкиВалюта        = УправленческийУчетПовтИсп.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Валюта");
	
	Для Каждого Элемент Из МассивДляУдаления Цикл
		МакетШапкиОтчета.Макет.Удалить(Элемент);
	КонецЦикла;
	
	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл 
		Если Макет = МакетШапкиОтчета Тогда
		Иначе
			Индекс = -1;
			МассивПоказателей = Новый Массив;
			МассивПоказателей.Добавить("БУ");
			//МассивПоказателей.Добавить("НУ");
			//МассивПоказателей.Добавить("ПР");
			//МассивПоказателей.Добавить("ВР");
			
			Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				Если ОбъектОтчет["Показатель" + ?(ТипЗнч(ИмяПоказателя) = Тип("КлючИЗначение"), ИмяПоказателя.Ключ, ИмяПоказателя)] Тогда
					Индекс = Индекс + 1;
				КонецЕсли;
			КонецЦикла;
			//Если ПоказательКонтроль Тогда 
			//	Индекс = Индекс + 1;					
			//КонецЕсли;
			
			Если ОбъектОтчет.ПоказательВалютнаяСумма И КоличествоПоказателей = 1 Тогда 
				
			ИначеЕсли ОбъектОтчет.ПоказательВалютнаяСумма Тогда
				Индекс = Индекс + 1;				
				Если МакетГруппировкиВалюта.Найти(Макет) <> Неопределено Тогда
					
				Иначе
					Макет.Макет.Удалить(Макет.Макет[Индекс]);
					Индекс = Индекс - 1;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоПоказателей = КоличествоПоказателей - ОбъектОтчет.ПоказательВалютнаяСумма;
	Если КоличествоПоказателей > 0 Тогда
		ЗначенияПоказателей = Новый Массив(6, КоличествоПоказателей);
		Для Каждого Массив Из ЗначенияПоказателей Цикл
			Для Индекс = 0 По КоличествоПоказателей - 1 Цикл
				Массив[Индекс] = 0;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ВременныеДанныеОтчета = Новый Структура;
	ВременныеДанныеОтчета.Вставить("МакетШапкиОтчета"     , МакетШапкиОтчета);
	ВременныеДанныеОтчета.Вставить("МакетСчет"            , МакетГруппировкиСчет);
	ВременныеДанныеОтчета.Вставить("МакетПодвал"          , МакетПодвалаОтчета);
	ВременныеДанныеОтчета.Вставить("КоличествоПоказателей", КоличествоПоказателей);
	ВременныеДанныеОтчета.Вставить("ЗначенияПоказателей"  , ЗначенияПоказателей);
	
	Если ТипЗнч(ОбъектОтчет) = Тип("Структура") Тогда
		ОбъектОтчет.Вставить("ВременныеДанныеОтчета", ВременныеДанныеОтчета);	
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередВыводомЭлементаРезультата(МакетКомпоновки, ДанныеРасшифровки, ЭлементРезультата, Отказ = Ложь, ОбъектОтчет) Экспорт
	ВременныеДанныеОтчета = ОбъектОтчет.ВременныеДанныеОтчета;
	Попытка
		Если ЭлементРезультата.ЗначенияПараметров.П1.Значение = null 
			И ВременныеДанныеОтчета.МакетШапкиОтчета.Имя <> ЭлементРезультата.Макет
			И ЭлементРезультата.Макет <> ВременныеДанныеОтчета.МакетПодвал.Имя Тогда
			Отказ = Истина;
		КонецЕсли;                                                          
	Исключение
	КонецПопытки;
	
	СмещениеПоСтроке = ВременныеДанныеОтчета.МакетШапкиОтчета.Макет[0].Ячейки.Количество() - 7;
	// Накапливаем суммы по корневым счетам
	Попытка
		Если ВременныеДанныеОтчета.МакетСчет.Найти(МакетКомпоновки.Макеты[ЭлементРезультата.Макет]) <> Неопределено Тогда
			ЗначениеСчет = ДанныеРасшифровки.Элементы[ЭлементРезультата.ЗначенияПараметров.П2.Значение].ПолучитьПоля()[0].Значение;
			Если Не ЗначениеЗаполнено(ЗначениеСчет.Родитель) И Не ЗначениеСчет.Забалансовый Тогда
				Для Индекс = 0 По ВременныеДанныеОтчета.КоличествоПоказателей - 1 Цикл
					Для ПодИндекс = 1 По 6 Цикл
						Значение = ЭлементРезультата.ЗначенияПараметров[Строка(МакетКомпоновки.Макеты[ЭлементРезультата.Макет].Макет[Индекс].Ячейки[ПодИндекс + СмещениеПоСтроке].Элементы[0].Значение)].Значение;
						//Если Не ЗначениеСчет.НалоговыйУчет И Индекс = (ВременныеДанныеОтчета.КоличествоПоказателей - 1)
						//	  Тогда
						//	Значение = 0;
						//КонецЕсли;
						ВременныеДанныеОтчета.ЗначенияПоказателей[ПодИндекс - 1][Индекс] = ВременныеДанныеОтчета.ЗначенияПоказателей[ПодИндекс - 1][Индекс] + Значение;
					КонецЦикла;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли; 
	Исключение
	КонецПопытки;
	
	// Проставляем накопленные суммы в подвал отчета
	Если ЭлементРезультата.Макет = ВременныеДанныеОтчета.МакетПодвал.Имя Тогда
		Для Индекс = 0 По ВременныеДанныеОтчета.КоличествоПоказателей - 1 Цикл
			Для ПодИндекс = 1 По 6 Цикл
				ЭлементРезультата.ЗначенияПараметров[Строка(ВременныеДанныеОтчета.МакетПодвал.Макет[Индекс].Ячейки[ПодИндекс + СмещениеПоСтроке].Элементы[0].Значение)].Значение = ВременныеДанныеОтчета.ЗначенияПоказателей[ПодИндекс - 1][Индекс];
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(Результат, ОбъектОтчет) Экспорт
	
	//Удалим строки с высотой равной 1
	Индекс = Результат.ВысотаТаблицы;
	Пока Индекс > 0 Цикл
		ИндексСтроки = "R" + Формат(Индекс,"ЧГ=0");
		Если Результат.Область(ИндексСтроки).ВысотаСтроки = 1 Тогда
			Результат.УдалитьОбласть(Результат.Область(ИндексСтроки), ТипСмещенияТабличногоДокумента.ПоВертикали);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	УправленческийУчетПовтИсп.ОбработкаРезультатаОтчета(ОбъектОтчет, Результат);
	
	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = ОбъектОтчет.ВысотаШапки;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + ОбъектОтчет.ВысотаШапки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	УправленческийУчетПовтИсп.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

НаборПоказателей = Новый Массив;
НаборПоказателей.Добавить("БУ");
//НаборПоказателей.Добавить("НУ");
//НаборПоказателей.Добавить("ПР");
//НаборПоказателей.Добавить("ВР");
//НаборПоказателей.Добавить("Контроль");
НаборПоказателей.Добавить("ВалютнаяСумма");