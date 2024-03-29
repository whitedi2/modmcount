﻿// Получает параметр вывода компоновщика настроек или настройки СКД
//
// Параметры:
//		КомпоновщикНастроекГруппировка - компоновщик настроек или настройка/группировка СКД
//		ИмяПараметра - имя параметра СКД
//
Функция ПолучитьПараметрВывода(Настройка, ИмяПараметра) Экспорт
	
	МассивПараметров   = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяПараметра, ".");
	УровеньВложенности = МассивПараметров.Количество();
	
	Если УровеньВложенности > 1 Тогда
		ИмяПараметра = МассивПараметров[0];		
	КонецЕсли;
	
	Если ТипЗнч(Настройка) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройка.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Иначе
		ЗначениеПараметра = Настройка.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	КонецЕсли;
	
	Если УровеньВложенности > 1 Тогда
		Для Индекс = 1 По УровеньВложенности - 1 Цикл
			ИмяПараметра = ИмяПараметра + "." + МассивПараметров[Индекс];
			ЗначениеПараметра = ЗначениеПараметра.ЗначенияВложенныхПараметров.Найти(ИмяПараметра); 
		КонецЦикла;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;  
	
КонецФункции

// Устанавливает параметр вывода компоновщика настроек или настройки СКД
//
// Параметры:
//		КомпоновщикНастроекГруппировка - компоновщик настроек или настройка/группировка СКД
//		ИмяПараметра - имя параметра СКД
//		Значение - значение параметра вывода СКД
//		Использование - Признак использования параметра. По умолчанию всегда принимается равным истине.
//
Функция УстановитьПараметрВывода(Настройка, ИмяПараметра, Значение, Использование = Истина) Экспорт
	
	ЗначениеПараметра = ПолучитьПараметрВывода(Настройка, ИмяПараметра);
	
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Использование = Использование;
		ЗначениеПараметра.Значение      = Значение;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

// Добавляет отбор в коллекцию отборов компоновщика или группы отборов
//
// Параметры:
//		ЭлементСтруктуры - элемент структуры
//		Поле             - имя поля, по которому добавляется отбор
//		Значение         - значение отбора
//		ВидСравнения     - вид сравнений компоновки данных (по умолчанию: вид сравнения)
//		Использование    - признак использования отбора (по умолчанию: истина)
//
Функция ДобавитьОтбор(ЭлементСтруктуры, Знач Поле, Значение, ВидСравнения = Неопределено, Использование = Истина, ВПользовательскиеНастройки = Ложь) Экспорт
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
		
		Если ВПользовательскиеНастройки Тогда
			Для Каждого ЭлементНастройки Из ЭлементСтруктуры.ПользовательскиеНастройки.Элементы Цикл	
				Если ЭлементНастройки.ИдентификаторПользовательскойНастройки = ЭлементСтруктуры.Настройки.Отбор.ИдентификаторПользовательскойНастройки Тогда
					Отбор = ЭлементНастройки;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
		
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	НовыйЭлемент = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйЭлемент.Использование  = Использование;
	НовыйЭлемент.ЛевоеЗначение  = Поле;
	НовыйЭлемент.ВидСравнения   = ВидСравнения;
	НовыйЭлемент.ПравоеЗначение = Значение;
	
	Возврат НовыйЭлемент;
	
КонецФункции

// Функция добавляет выбранное поле и возвращает элемент выбранного поля. 
//
// Параметры:
//		ЭлементСтруктуры - компоновщик настроек, настройка СКД, элемент структуры настройки отчета
//		Поле - имя поля, которое нужно добавить в СКД
//		Заголовок - заголовок добавляемого поля
//
Функция ДобавитьВыбранноеПоле(ЭлементСтруктуры, Знач Поле, Заголовок = Неопределено) Экспорт
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		ВыбранныеПоля = ЭлементСтруктуры.Настройки.Выбор;
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		ВыбранныеПоля = ЭлементСтруктуры.Выбор;
	Иначе
		ВыбранныеПоля = ЭлементСтруктуры;
	КонецЕсли;
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	ВыбранноеПоле = ВыбранныеПоля.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Поле;
	Если Заголовок <> Неопределено Тогда
		ВыбранноеПоле.Заголовок = Заголовок;
	КонецЕсли;
	
	Возврат ВыбранноеПоле;
	
КонецФункции

// Функция возвращает значение параметра компоновки данных
//
// Параметры:
//  Настройки - Пользовательские настройки СКД, Настройки СКД, Компоновщик настроек
//  Параметр - имя параметра СКД для которого нужно вернуть значение параметра
Функция ПолучитьПараметр(Настройки, Параметр) Экспорт
	
	ЗначениеПараметра = Неопределено;
	ПолеПараметр = ?(ТипЗнч(Параметр) = Тип("Строка"), Новый ПараметрКомпоновкиДанных(Параметр), Параметр);
	
	Если ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	ИначеЕсли ТипЗнч(Настройки) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из Настройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Настройки) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Для Каждого ЭлементНастройки Из Настройки.ПользовательскиеНастройки.Элементы Цикл
			Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ЭлементНастройки.Параметр = ПолеПараметр Тогда
				ЗначениеПараметра = ЭлементНастройки;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЗначениеПараметра = Неопределено Тогда
			ЗначениеПараметра = Настройки.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
		КонецЕсли;
	ИначеЕсли ТипЗнч(Настройки) = Тип("ДанныеРасшифровкиКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	ИначеЕсли ТипЗнч(Настройки) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.Найти(ПолеПараметр);
	ИначеЕсли ТипЗнч(Настройки) = Тип("ОформлениеКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройки.НайтиЗначениеПараметра(ПолеПараметр);
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

// Функция устанавливает значение параметра компоновки данных
//
// Параметры:
//		Настройки     - Пользовательские настройки СКД, Настройки СКД, Компоновщик настроек
//		Параметр      - имя параметра СКД для которого нужно вернуть значение параметра
//      Значение      - значение параметра
//		Использование - Признак использования параметра. По умолчанию всегда принимается равным истине.
//
Функция УстановитьПараметр(Настройки, Параметр, Значение, Использование = Истина) Экспорт
	
	ЗначениеПараметра = ПолучитьПараметр(Настройки, Параметр);
	
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Использование = Использование;
		ЗначениеПараметра.Значение      = Значение;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

Функция ПолучитьПредставлениеПериода(НачалоПериода = '00010101', КонецПериода = '00010101', ТолькоДаты  = Ложь) Экспорт
	
	ТекстПериод = "";
	
	Если ЗначениеЗаполнено(КонецПериода) Тогда 
		Если КонецПериода >= НачалоПериода Тогда
			ТекстПериод = ?(ТолькоДаты, "", " за ") + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(КонецПериода), "ФП = Истина");
		Иначе
			ТекстПериод = "";
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(НачалоПериода) И Не ЗначениеЗаполнено(КонецПериода) Тогда
		ТекстПериод = ?(ТолькоДаты, "", " за ") + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(Дата(3999, 11, 11)), "ФП = Истина");
		ТекстПериод = СтрЗаменить(ТекстПериод, Сред(ТекстПериод, Найти(ТекстПериод, " - ")), " - ...");
	КонецЕсли;
	
	Возврат ТекстПериод;
	
КонецФункции

Функция ПолучитьИдентификаторОбъекта(Форма) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Форма.ИмяФормы, ".")[1];
	
КонецФункции

Функция ПростойТип(Значение) Экспорт
	
	ОписаниеПростыхТипов = Новый ОписаниеТипов("Дата, Строка, Булево, Число");
	
	Возврат ОписаниеПростыхТипов.СодержитТип(ТипЗнч(Значение));
	
КонецФункции

Функция НачалоПериода(Период, Периодичность) Экспорт
	
	НачалоПериода = Период;
	Если Периодичность = 6 Тогда       //День
		НачалоПериода = НачалоДня(Период);
	ИначеЕсли Периодичность = 7 Тогда  //Неделя
		НачалоПериода = НачалоНедели(Период);
	ИначеЕсли Периодичность = 8 Тогда  //Декада
		Если День(Период) <= 10 Тогда
			НачалоПериода = Дата(Год(Период), Месяц(Период), 1);
		ИначеЕсли День(Период) > 10 И День(Период) <= 20 Тогда
			НачалоПериода = Дата(Год(Период), Месяц(Период), 11);
		Иначе
			НачалоПериода = Дата(Год(Период), Месяц(Период), 21);
		КонецЕсли;
	ИначеЕсли Периодичность = 9 Тогда  //Месяц
		НачалоПериода = НачалоМесяца(Период);
	ИначеЕсли Периодичность = 10 Тогда //Квартал
		НачалоПериода = НачалоКвартала(Период);
	ИначеЕсли Периодичность = 11 Тогда //Полугодие
		НачалоПериода = ?(Месяц(Период) < 7, НачалоДня(Дата(Год(Период), 1, 1)), НачалоДня(Дата(Год(Период), 7, 1)));
	ИначеЕсли Периодичность = 12 Тогда //Год
		НачалоПериода = НачалоГода(Период);
	КонецЕсли;
	
	Возврат НачалоПериода;
	
КонецФункции

Функция КонецПериода(Период, Периодичность) Экспорт
	
	КонецПериода = Период;
	Если Периодичность = 6 Тогда       //День
		КонецПериода = КонецДня(Период);
	ИначеЕсли Периодичность = 7 Тогда  //Неделя
		КонецПериода = КонецНедели(Период);
	ИначеЕсли Периодичность = 8 Тогда  //Декада
		Если День(Период) > 20 Тогда
			КонецПериода = КонецМесяца(Период);
		Иначе
			КонецПериода = КонецДня(Период + 10 * 86400 - 1);
		КонецЕсли; 
	ИначеЕсли Периодичность = 9 Тогда  //Месяц
		КонецПериода = КонецМесяца(Период);
	ИначеЕсли Периодичность = 10 Тогда //Квартал
		КонецПериода = КонецКвартала(Период);
	ИначеЕсли Периодичность = 11 Тогда //Полугодие
		КонецПериода = ?(Месяц(Период) < 7, КонецДня(Дата(Год(Период), 6, 30)), КонецДня(Дата(Год(Период), 12, 31)));
	ИначеЕсли Периодичность = 12 Тогда //Год
		КонецПериода = КонецГода(Период);
	КонецЕсли;
	
	Возврат КонецПериода;
	
КонецФункции

Функция ПолучитьНаименованиеЗаданияВыполненияОтчета(Форма) Экспорт
	
	НаименованиеЗадания = НСтр("ru = 'Выполнение отчета: %1'");
	ИмяОтчета = ПолучитьИдентификаторОбъекта(Форма);
	НаименованиеЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НаименованиеЗадания, ИмяОтчета);
	
	Возврат НаименованиеЗадания;
	
КонецФункции

Функция ПолучитьСвойствоПоля(ЭлементСтруктура, Поле, Свойство = "Заголовок") Экспорт
	
	Если ТипЗнч(ЭлементСтруктура) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Коллекция = ЭлементСтруктура.Настройки.ДоступныеПоляВыбора;
	Иначе
		Коллекция = ЭлементСтруктура;
	КонецЕсли;
	
	ПолеСтрокой = Строка(Поле);
	ПозицияКвадратнойСкобки = Найти(ПолеСтрокой, "[");
	Окончание = "";
	Заголовок = "";
	Если ПозицияКвадратнойСкобки > 0 Тогда
		Окончание = Сред(ПолеСтрокой, ПозицияКвадратнойСкобки);
		ПолеСтрокой = Лев(ПолеСтрокой, ПозицияКвадратнойСкобки - 2);
	КонецЕсли;
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолеСтрокой, ".");
	
	Если Не ПустаяСтрока(Окончание) Тогда
		МассивСтрок.Добавить(Окончание);
	КонецЕсли;
	
	ДоступныеПоля = Коллекция.Элементы;
	ПолеПоиска = "";
	Для Индекс = 0 По МассивСтрок.Количество() - 1 Цикл
		ПолеПоиска = ПолеПоиска + ?(Индекс = 0, "", ".") + МассивСтрок[Индекс];
		ДоступноеПоле = ДоступныеПоля.Найти(ПолеПоиска);
		Если ДоступноеПоле <> Неопределено Тогда
			ДоступныеПоля = ДоступноеПоле.Элементы;
		КонецЕсли;
	КонецЦикла;
	
	Если ДоступноеПоле <> Неопределено Тогда
		Если Свойство = "ДоступноеПоле" Тогда
			Результат = ДоступноеПоле;
		Иначе
			Результат = ДоступноеПоле[Свойство]; 
		КонецЕсли;
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура СкрыватьНастройкиПриФормированииОтчета(Форма, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		СкрыватьНастройкиПриФормированииОтчета = Форма.СкрыватьНастройкиПриФормированииОтчета;
		ПанельНастроек       = Форма.Элементы.ГруппаПанельНастроек;
		КнопкаПанельНастроек = Форма.Элементы.ПанельНастроек;
	Иначе
		СкрыватьНастройкиПриФормированииОтчета = ДополнительныеПараметры.СкрыватьНастройкиПриФормированииОтчета;
		ПанельНастроек       = Форма.Элементы[ДополнительныеПараметры.ИмяГруппаПанельНастроек];
		Если ДополнительныеПараметры.Свойство("ИмяКнопкаПанельНастроек") Тогда
			КнопкаПанельНастроек = Форма.Элементы[ДополнительныеПараметры.ИмяКнопкаПанельНастроек];
		Иначе
			КнопкаПанельНастроек = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если СкрыватьНастройкиПриФормированииОтчета Тогда
		Если ПанельНастроек.Видимость Тогда
			Форма.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПанельНастроекСкрытаАвтоматически", Истина);
		КонецЕсли;
		ПанельНастроек.Видимость = Ложь;
		Если КнопкаПанельНастроек <> Неопределено Тогда
			ИзменитьЗаголовокКнопкиПанельНастроек(КнопкаПанельНастроек, Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьЗаголовокКнопкиПанельНастроек(Кнопка, ВидимостьПанелиНастроек) Экспорт
	
	Если ВидимостьПанелиНастроек Тогда
		Кнопка.Заголовок = НСтр("ru = 'Скрыть настройки'");
	Иначе
		Кнопка.Заголовок = НСтр("ru = 'Показать настройки'");
	КонецЕсли;
		
КонецПроцедуры

Функция ПолучитьЗначениеПериодичности(Периодичность, НачалоПериода, КонецПериода) Экспорт
	
	Результат = Периодичность;
	Если Периодичность = 0 Тогда
		Если ЗначениеЗаполнено(НачалоПериода)
			И ЗначениеЗаполнено(КонецПериода) Тогда
			Разность = КонецПериода - НачалоПериода;
			Если Разность / 86400 < 45 Тогда
				Результат = 6; // день
			Иначе
				Результат = 9; // месяц
			КонецЕсли;
		Иначе
			Результат = 9; // месяц
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
