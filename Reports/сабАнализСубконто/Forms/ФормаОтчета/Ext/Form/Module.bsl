﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода"                    , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                     , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("Подразделение"                    , Отчет.Подразделение);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыОтчета.Вставить("ПоказательБУ"                     , Отчет.ПоказательБУ);
	ПараметрыОтчета.Вставить("ПоказательНУ"                     , Отчет.ПоказательНУ);
	ПараметрыОтчета.Вставить("ПоказательПР"                     , Отчет.ПоказательПР);
	ПараметрыОтчета.Вставить("ПоказательВР"                     , Отчет.ПоказательВР);
	ПараметрыОтчета.Вставить("ПоказательВалютнаяСумма"          , Отчет.ПоказательВалютнаяСумма);
	ПараметрыОтчета.Вставить("ПоказательКоличество"             , Отчет.ПоказательКоличество);
	ПараметрыОтчета.Вставить("ПоказательКонтроль"               , Отчет.ПоказательКонтроль);
	ПараметрыОтчета.Вставить("РазвернутоеСальдо"                , Отчет.РазвернутоеСальдо);
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"    , Отчет.РазмещениеДополнительныхПолей);
	ПараметрыОтчета.Вставить("Периодичность"                    , Отчет.Периодичность);
	ПараметрыОтчета.Вставить("СписокВидовСубконто"              , Отчет.СписокВидовСубконто);
	ПараметрыОтчета.Вставить("ПоСубсчетам"                      , Отчет.ПоСубсчетам);
	ПараметрыОтчета.Вставить("Группировка"                      , Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("ДополнительныеПоля"               , Отчет.ДополнительныеПоля.Выгрузить());
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , ВыводитьПодвал);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , МакетОформления);	
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , УправленческиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.Настройки);
	ПараметрыОтчета.Вставить("НаборПоказателей"                 , Отчеты[ПараметрыОтчета.ИдентификаторОтчета].ПолучитьНаборПоказателей());
	//ПараметрыОтчета.Вставить("ОтветственноеЛицо"                , Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры);
	ПараметрыОтчета.Вставить("ВыводитьЕдиницуИзмерения"         , ВыводитьЕдиницуИзмерения);
	ПараметрыОтчета.Вставить("Период"         					, Отчет.Период);
	ПараметрыОтчета.Вставить("СценарийПлана"         			, Отчет.СценарийПлана);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;

	ТекстСубконто = "";
	Для Каждого ВидСубконто Из Отчет.СписокВидовСубконто Цикл
		ТекстСубконто = ТекстСубконто + ВидСубконто + ", ";	
	КонецЦикла;
	Если Не ПустаяСтрока(ТекстСубконто) Тогда
		ТекстСубконто = Лев(ТекстСубконто, СтрДлина(ТекстСубконто) - 2);
	КонецЕсли;
	
	ЗаголовокОтчета = "Анализ субконто " + ТекстСубконто + УправленческиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода);
	
	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + УправленческиеОтчетыВызовСервераПовтИсп.ПолучитьТекстОрганизация(Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	
	Если Режим = "Выбор" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если ДоступноеПоле.Ресурс Тогда
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	КоличествоСубконто = 0;
	Для Каждого ЭлементСписка Из Отчет.СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда
			КоличествоСубконто = КоличествоСубконто + 1;
		КонецЕсли;
	КонецЦикла;
	
	Для Индекс = КоличествоСубконто + 1 По 3 Цикл
		СписокПолей.Добавить("Субконто" + Индекс);
	КонецЦикла;
	
	Если Не ЕстьУчетПоПодразделениям Тогда
		СписокПолей.Добавить("Подразделение");
	КонецЕсли;
	
	Если Не Отчет.ПоказательВалютнаяСумма Тогда
		СписокПолей.Добавить("Валюта");
	КонецЕсли;
	
	Если Режим = "Группировка" Тогда
		СписокПолей.Добавить("Счет");
		СписокПолей.Добавить("СальдоНаНачалоПериода");
		СписокПолей.Добавить("ОборотыЗаПериод");
		СписокПолей.Добавить("СальдоНаКонецПериода");
	ИначеЕсли Режим = "Выбор" Тогда
		СписокПолей.Добавить("СальдоНаНачалоПериода");
		СписокПолей.Добавить("ОборотыЗаПериод");
		СписокПолей.Добавить("СальдоНаКонецПериода");
	ИначеЕсли Режим = "Отбор" ИЛИ Режим = "Порядок" Тогда
		УправленческиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("СкрыватьНастройкиПриФормированииОтчета", СкрыватьНастройкиПриФормированииОтчета);
	

	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	//Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		УправленческиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	//Иначе
	//	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
	//		УникальныйИдентификатор, 
	//		"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет", 
	//		ПараметрыОтчета, 
	//		БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
	//		
	//	АдресХранилища       = РезультатВыполнения.АдресХранилища;
	//	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;		
	//КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	УправленческиеОтчетыКлиентСервер.СкрыватьНастройкиПриФормированииОтчета(ЭтаФорма);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура СписокВидовСубконтоПриИзмененииСервер()
	
	ИзменениеСхемыКомпоновкиДанныхНаСервере();
	
	ЗаполнитьПризнакиУчета();
	
	ЗаполняемыеНастройки = Новый Структура("Показатели, Группировка, Отбор",
	                                       Истина, Истина, Истина);
	ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеСхемыКомпоновкиДанныхНаСервере() Экспорт
	
	Схема = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
		
	ИмяПоляПрефикс = "Субконто";
	
	// Изменение представления и наложения ограничения типа значения
	Индекс = 1;
	Для Каждого ВидСубконто Из Отчет.СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ВидСубконто.Значение) Тогда
			Поле = Схема.НаборыДанных.ОсновнойНаборДанных.Поля.Найти(ИмяПоляПрефикс + Индекс);
			Если Поле <> Неопределено Тогда
				Поле.ТипЗначения = ВидСубконто.Значение.ТипЗначения;
				Поле.Заголовок   = Строка(ВидСубконто.Значение);
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(Схема, СхемаКомпоновкиДанных);
	Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПризнакиУчета()
	
	МассивСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из Отчет.СписокВидовСубконто Цикл 
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда
			МассивСубконто.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ВС1.Ссылка.Количественный) КАК Количественный,
	|	МАКСИМУМ(ВС1.Ссылка.Валютный) КАК Валютный,
	|	ЛОЖЬ КАК НалоговыйУчет,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВС1.Ссылка) КАК КоличествоСчетов,
	|	МАКСИМУМ(ВС1.Ссылка.УчетПоПодразделениям) КАК УчетПоПодразделениям
	|ИЗ
	|	ПланСчетов.Учетный.ВидыСубконто КАК ВС1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Учетный.ВидыСубконто КАК ВС2
	|		ПО ВС1.Ссылка = ВС2.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Учетный.ВидыСубконто КАК ВС3
	|		ПО ВС1.Ссылка = ВС3.Ссылка
	|ГДЕ
	|	ВС1.ВидСубконто = &ВидСубконто1
	|	И ВС2.ВидСубконто = &ВидСубконто2
	|	И ВС3.ВидСубконто = &ВидСубконто3";
	Индекс = 3;
	Пока Индекс <> 0 Цикл
		Если Индекс > МассивСубконто.Количество() Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВС" + Индекс + ".ВидСубконто = &ВидСубконто" + Индекс, "ИСТИНА");	
		КонецЕсли;	
		Индекс = Индекс - 1;
	КонецЦикла;
	Для Индекс = 1 По МассивСубконто.Количество() Цикл
		Запрос.УстановитьПараметр("ВидСубконто" + Индекс, МассивСубконто[Индекс - 1]);
	КонецЦикла;
	ЕстьВалюта               = Ложь;
	ЕстьКоличество           = Ложь;
	ЕстьНалоговыйУчет        = Ложь;
	ЕстьУчетПоПодразделениям = Ложь;
	ЕстьСчета                = Ложь;	
	
	Если МассивСубконто.Количество() = 0 Тогда
		ЕстьВалюта               = Истина;
		ЕстьКоличество           = Истина;
		ЕстьНалоговыйУчет        = Истина;
		ЕстьУчетПоПодразделениям = Истина;
		ЕстьСчета                = Истина;
	Иначе
		ВыборкаСчета = Запрос.Выполнить().Выбрать();
		Пока ВыборкаСчета.Следующий() Цикл
			ЕстьВалюта               = ?(ВыборкаСчета.Валютный             = Истина, Истина, Ложь);
			ЕстьКоличество           = ?(ВыборкаСчета.Количественный       = Истина, Истина, Ложь);
			ЕстьНалоговыйУчет        = ?(ВыборкаСчета.НалоговыйУчет        = Истина, Истина, Ложь);
			ЕстьУчетПоПодразделениям = ?(ВыборкаСчета.УчетПоПодразделениям = Истина, Истина, Ложь);
			ЕстьСчета                = ?(ВыборкаСчета.КоличествоСчетов     = 0     , Ложь  , Истина);  
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки) Экспорт
	
	МассивСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из Отчет.СписокВидовСубконто Цикл 
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда
			МассивСубконто.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ИмяПоляПрефикс = "Субконто";
	
	Если ЗаполняемыеНастройки.Свойство("Показатели") Тогда
		Если ЗаполняемыеНастройки.Показатели Тогда
			// Управление показателями
			Отчет.ПоказательБУ            = Истина;
			Отчет.ПоказательНУ            = Ложь;
			Отчет.ПоказательПР            = Ложь;
			Отчет.ПоказательВР            = Ложь;
			Отчет.ПоказательКонтроль      = Ложь;
			Отчет.РазвернутоеСальдо       = Ложь;
			Отчет.ПоказательВалютнаяСумма = ЕстьВалюта;
			Отчет.ПоказательКоличество    = ЕстьКоличество;				
		КонецЕсли;
	КонецЕсли;

	Если ЗаполняемыеНастройки.Свойство("Группировка") Тогда
		Если ЗаполняемыеНастройки.Группировка Тогда
			// Добавление группировок с соответствии с выбранным счетом	
			Отчет.Группировка.Очистить();
			
			Если ЕстьУчетПоПодразделениям Тогда
				НоваяСтрока = Отчет.Группировка.Добавить();
				НоваяСтрока.Поле           = "Подразделение";
				НоваяСтрока.Использование  = Ложь;
				НоваяСтрока.Представление  = "Подразделение";
				НоваяСтрока.ТипГруппировки = 0;	
			КонецЕсли;
			
			Для Индекс = 1 По МассивСубконто.Количество() Цикл
				НоваяСтрока = Отчет.Группировка.Добавить();
				Поле = Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс));
				НоваяСтрока.Поле           = Поле.Поле;
				НоваяСтрока.Использование  = Истина;
				НоваяСтрока.Представление  = Поле.Заголовок;
				НоваяСтрока.ТипГруппировки = 0;	
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;
	
	Если ЗаполняемыеНастройки.Свойство("Отбор") Тогда
		Если ЗаполняемыеНастройки.Отбор Тогда
			// Добавление неактивных отборов по субконто в соответствии с выбранным счетом
			ОтборыДляУдаления = Новый Массив;
			Для Каждого ЭлементОтбора Из Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
				Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда 
					Если Найти(ЭлементОтбора.ЛевоеЗначение, "Субконто") > 0 ИЛИ Строка(ЭлементОтбора.ЛевоеЗначение) = "Валюта"
						ИЛИ (Найти(ЭлементОтбора.ЛевоеЗначение, "Подразделение") = 1 И НЕ Отчет.Счет.УчетПоПодразделениям) Тогда
						ОтборыДляУдаления.Добавить(ЭлементОтбора);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого ЭлементОтбора Из ОтборыДляУдаления Цикл
				Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
			КонецЦикла;
			
			Для Индекс = 1 По МассивСубконто.Количество() Цикл
				ПолеДляПоиска = Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс);
				Поле = Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(ПолеДляПоиска);
				НовыйЭлементОтбора = УправленческиеОтчетыКлиентСервер.ДобавитьОтбор(Отчет.КомпоновщикНастроек, ИмяПоляПрефикс + Индекс, 
										МассивСубконто[Индекс - 1].ТипЗначения.ПривестиЗначение(Неопределено),, Ложь);	
				Для Каждого Отбор из ОтборыДляУдаления Цикл
					Если МассивСубконто[Индекс - 1].ТипЗначения.СодержитТип(ТипЗнч(Отбор.ПравоеЗначение)) Тогда
						ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора,Отбор,"ПравоеЗначение, ВидСравнения, Использование");
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			
			Если Не ЕстьУчетПоПодразделениям Тогда
				Отчет.Подразделение = Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ПоказательНУ.Доступность            = Форма.ЕстьНалоговыйУчет;
	Элементы.ПоказательПР.Доступность            = Форма.ЕстьНалоговыйУчет;
	Элементы.ПоказательВР.Доступность            = Форма.ЕстьНалоговыйУчет;
	Элементы.ПоказательКонтроль.Доступность      = Форма.ЕстьНалоговыйУчет;	
	Элементы.РазвернутоеСальдо.Доступность       = Форма.ЕстьСчета;
	Элементы.ПоказательБУ.Доступность            = Форма.ЕстьСчета;
	Элементы.ПоказательВалютнаяСумма.Доступность = Форма.ЕстьВалюта;
	Элементы.ПоказательКоличество.Доступность    = Форма.ЕстьКоличество;
	
	//Форма.Период = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
	//	Форма.ВидПериода, Форма.Отчет.НачалоПериода, Форма.Отчет.КонецПериода);
	//	
	//ВыборПериодаКлиентСервер.ПереключитьТекущуюСтраницуВыбораПериода(Форма.ВидПериода, Элементы.ГруппаПоляВводаПериода);	
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата"              , Отчет.КонецПериода);
	СписокПараметров.Вставить("СчетУчета"         , Неопределено);
	СписокПараметров.Вставить("Номенклатура"      , Неопределено);
	СписокПараметров.Вставить("Склад"             , Неопределено);
	СписокПараметров.Вставить("Организация"       , Отчет.Организация);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = УправленческиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	УправленческиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ ТАБЛИЧНОГО ДОКУМЕНТА

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправленческиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УправленческийУчетПовтИсп.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Свойство("ИДРасшифровки") Тогда
		БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	КонецЕсли;
	
	Отчет.СписокВидовСубконто.ТипЗначения = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыСубконто");
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
		
	//ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	//ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	//Если ПодключитьОбработчикОжидания Тогда		
	//	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	//	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	//	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	//КонецЕсли;
	
	УправленческиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
	Элементы.ПанельНастроек.Пометка = Элементы.ГруппаПанельНастроек.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	УправленческиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОтменитьВыполнениеЗадания();
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	УправленческиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	УправленческийУчетПовтИсп.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	УправленческиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	УправленческийУчетПовтИсп.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	ИзменениеСхемыКомпоновкиДанныхНаСервере();
			
	ЗаполнитьПризнакиУчета();

	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПанельНастроек(Команда)
	
	Элементы.ГруппаПанельНастроек.Видимость = Не Элементы.ГруппаПанельНастроек.Видимость;
	УправленческиеОтчетыКлиентСервер.ИзменитьЗаголовокКнопкиПанельНастроек(
		Элементы.ПанельНастроек, Элементы.ГруппаПанельНастроек.Видимость);
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	//ОбновитьТекстЗаголовка(ЭтаФорма);
	НачалоПериода = Отчет.Период.ДатаНачала;
	КонецПериода = Отчет.Период.ДатаОкончания;
	
	Отчет.НачалоПериода = НачалоПериода;
	Отчет.КонецПериода = КонецПериода;
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	//ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация,
	//	Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
	УправленческиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	//ОбщегоНазначенияБПКлиент.ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка,
	//	ПолеОрганизация, СоответствиеОрганизаций);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	//ОбщегоНазначенияБПКлиент.ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, 
	//	СоответствиеОрганизаций, Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
	УправленческиеОтчетыКлиент.ПодразделениеПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	УправленческиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ВИДЫ СУБКОНТО

&НаКлиенте
Процедура СписокВидовСубконтоПриИзменении(Элемент)
	
	СписокВидовСубконтоПриИзмененииСервер();
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ПОКАЗАТЕЛИ

&НаКлиенте
Процедура ПоказательБУПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательНУПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательПРПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВРПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательКонтрольПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВалютнаяСуммаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательКоличествоПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ГРУППИРОВКА

&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоСубсчетамПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	УправленческиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	УправленческиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	УправленческиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	УправленческиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	УправленческиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	УправленческиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ДОПОЛНИТЕЛЬНЫЕ ПОЛЯ

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	УправленческиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	УправленческиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ СОРТИРОВКА

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	УправленческиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	УправленческиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОФОРМЛЕНИЕ

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	УправленческиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЕдиницуИзмеренияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

// Процедура управляет состояние поля табличного документа
//
//Параметры:
//  ПолеТабличногоДокумента – ПолеФормы – поле формы с видом ПолеТабличногоДокумента,
//                            для которого необходимо установить состояние.
//  Состояние               – Строка – задает вид состояния.
//
&НаСервере
Процедура УстановитьСостояниеПоляТабличногоДокумента(ПолеТабличногоДокумента, Состояние = "НеИспользовать") Экспорт
	
	Если ТипЗнч(ПолеТабличногоДокумента) = Тип("ПолеФормы") 
		И ПолеТабличногоДокумента.Вид = ВидПоляФормы.ПолеТабличногоДокумента Тогда
		ОтображениеСостояния = ПолеТабличногоДокумента.ОтображениеСостояния;
		Если ВРег(Состояние) = "НЕИСПОЛЬЗОВАТЬ" Тогда
			ОтображениеСостояния.Видимость                      = Ложь;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
			ОтображениеСостояния.Картинка                       = Новый Картинка;
			ОтображениеСостояния.Текст                          = "";
		ИначеЕсли ВРег(Состояние) = "НЕАКТУАЛЬНОСТЬ" Тогда
			ОтображениеСостояния.Видимость                      = Истина;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
			ОтображениеСостояния.Картинка                       = Новый Картинка;
			ОтображениеСостояния.Текст                          = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" для получения отчета.'");;
		ИначеЕсли ВРег(Состояние) = "ФОРМИРОВАНИЕОТЧЕТА" Тогда  
			ОтображениеСостояния.Видимость                      = Истина;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
			ОтображениеСостояния.Картинка                       = БиблиотекаКартинок.ДлительнаяОперация48;
			ОтображениеСостояния.Текст                          = НСтр("ru = 'Отчет формируется...'");
		Иначе
			ВызватьИсключение(НСтр("ru = 'Недопустимое значение параметра (параметр номер ''2'')'"));
		КонецЕсли;
	Иначе
		ВызватьИсключение(НСтр("ru = 'Недопустимое значение параметра (параметр номер ''1'')'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрыватьНастройкиПриФормированииОтчетаПриИзменении(Элемент)
	ОбновитьНастройки();
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройки()
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("СкрыватьНастройкиПриФормированииОтчета", СкрыватьНастройкиПриФормированииОтчета);
КонецПроцедуры

