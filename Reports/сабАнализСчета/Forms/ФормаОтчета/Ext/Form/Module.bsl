﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
Процедура ОбновитьТекстЗаголовка(Форма)
	
	//Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = "Анализ счета " + Форма.Отчет.Счет + СтандартныеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Форма.Отчет.НачалоПериода, Форма.Отчет.КонецПериода);

	Если ЗначениеЗаполнено(Форма.Отчет.Организация) Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + УправленческийУчетПовтИсп.ПолучитьТекстОрганизация(Форма.Отчет.Организация, Ложь);
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
	
	Если ЗначениеЗаполнено(Отчет.Счет) Тогда 
		КоличествоСубконто = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет).КоличествоСубконто;
	Иначе
		КоличествоСубконто = 0;
	КонецЕсли;
	Для Индекс = КоличествоСубконто + 1 По 3 Цикл
		СписокПолей.Добавить("Субконто" + Индекс);
	КонецЦикла;
	
	Если Не УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет).УчетПоПодразделениям Тогда
		СписокПолей.Добавить("Подразделение");
	КонецЕсли;
	
	Если Режим = "Группировка" Тогда
		СписокПолей.Добавить("Счет");
		СписокПолей.Добавить("СальдоНаНачалоПериода");
		СписокПолей.Добавить("ОборотыЗаПериод");
		СписокПолей.Добавить("СальдоНаКонецПериода");
		СписокПолей.Добавить("КорСчет");
		СписокПолей.Добавить("Регистратор");
		Для Индекс = 1 По 3 Цикл
			СписокПолей.Добавить("КорСубконто" + Индекс);
		КонецЦикла;
	ИначеЕсли Режим = "Выбор" Тогда
		СписокПолей.Добавить("СальдоНаНачалоПериода");
		СписокПолей.Добавить("ОборотыЗаПериод");
		СписокПолей.Добавить("СальдоНаКонецПериода");
	ИначеЕсли Режим = "Отбор" ИЛИ Режим = "Порядок" Тогда
		СтандартныеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Процедура СформироватьОтчетСервер() Экспорт
	
	//Если Отчет.РежимРасшифровки Тогда
	//	сабОбщегоНазначения.СкорректироватьОтборыПоСубконто(Отчет.Компоновщикнастроек.Настройки, Отчет.Счет);
	//КонецЕсли;
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	
	Отч = РеквизитФормыВЗначение("Отчет");
	СтруктураПараметровОтчета = Новый Структура;
	СтруктураПараметровОтчета.Вставить("КомпоновщикНастроек", Неопределено);
	СтруктураПараметровОтчета.Вставить("КомпоновщикНастроекНастройки", Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	СтруктураПараметровОтчета.Вставить("ДополнительныеПоля", Отчет.ДополнительныеПоля.Выгрузить());
	СтруктураПараметровОтчета.Вставить("ИмяОтчета", "сабАнализСчета");
	СтруктураПараметровОтчета.Вставить("Группировка", Отчет.Группировка.Выгрузить());
	СтруктураПараметровОтчета.Вставить("ГруппировкаКор", Отчет.ГруппировкаКор.Выгрузить());
	
	Для каждого ТекЭл Из Метаданные.Отчеты.сабАнализСчета.Реквизиты Цикл
		СтруктураПараметровОтчета.Вставить(ТекЭл.Имя, Отчет[ТекЭл.Имя]);	
	КонецЦикла;
	НаборПоказателей2 = Новый Структура;
	НаборПоказателей2.Вставить("БУ", Метаданные.Отчеты.сабАнализСчета.Реквизиты.ПоказательБУ.Синоним);
	НаборПоказателей2.Вставить("ВалютнаяСумма", Метаданные.Отчеты.сабАнализСчета.Реквизиты.ПоказательВалютнаяСумма.Синоним);
	НаборПоказателей2.Вставить("Количество", Метаданные.Отчеты.сабАнализСчета.Реквизиты.ПоказательКоличество.Синоним);
	НаборПоказателей2.Вставить("Крахмал", Метаданные.Отчеты.сабАнализСчета.Реквизиты.ПоказательКрахмал.Синоним);
	СтруктураПараметровОтчета.Вставить("НаборПоказателей", НаборПоказателей2);
	СтруктураПараметровОтчета.Вставить("ИдентификаторОбъекта", "ОтчетОбъект.сабАнализСчета");
	
	ПараметрыОтчета = Новый Структура("ОтчетОбъект, Результат, ДанныеРасшифровки, Схема, ВыводитьПолностью", СтруктураПараметровОтчета , Результат, ДанныеРасшифровки, Отч.СхемаКомпоновкиДанных, Истина);
	
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
	УникальныйИдентификатор,
	"сабОбщегоНазначения.ВывестиТиповойОтчет",
	ПараметрыОтчета,
	НСтр("ru = 'Формирование отчета'"));
	
	АдресХранилища       = РезультатВыполнения.АдресХранилища;
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	ЗаданиеВыполнено 	 = РезультатВыполнения.ЗаданиеВыполнено;
	//сабОбщегоНазначения.ВывестиТиповойОтчет(ПараметрыОтчета, АдресХранилища);
	 
		
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаСервере
Процедура СчетПриИзмененииСервер()
	
	ИзменениеСхемыКомпоновкиДанных();
	
	ЗаполняемыеНастройки = Новый Структура("Показатели, Группировка, Отбор",
	                                       Истина, Истина, Истина);
	ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки);
	
	УправлениеФормой(ЭтаФорма);	
	
	ДобавитьНаправлениеКГруппировке();
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеСхемыКомпоновкиДанных() Экспорт
	
	Схема = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	Счет = Отчет.Счет;
	Если ЗначениеЗаполнено(Счет) Тогда
		
		КоличествоСубконто = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет).КоличествоСубконто;
		
		ИмяПоляПрефикс = "Субконто";
		
		МассивНаборовДанных = Новый Массив;
		МассивНаборовДанных.Добавить("НаборДанных1");
		//МассивНаборовДанных.Добавить("Обороты");
		
		// Изменение представления и наложения ограничения типа значения
		Для Индекс = 1 По КоличествоСубконто Цикл
			Для Каждого ЭлементМассива Из МассивНаборовДанных Цикл
				Набор = Схема.НаборыДанных[ЭлементМассива];
				Поле = Набор.Поля.Найти(ИмяПоляПрефикс + Индекс);
				Если Поле <> Неопределено Тогда
					ТипЗначения = Счет.ВидыСубконто[Индекс - 1].ВидСубконто.ТипЗначения;
					Поле.ТипЗначения = ТипЗначения;
					Поле.Заголовок   = Счет.ВидыСубконто[Индекс - 1].ВидСубконто.Наименование;
				КонецЕсли;
			КонецЦикла;	
		КонецЦикла;
		
		СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(Схема, СхемаКомпоновкиДанных);
		Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки) Экспорт
	
	КоличествоСубконто = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет).КоличествоСубконто;

	ИмяПоляПрефикс = "Субконто";
	
	Если ЗаполняемыеНастройки.Свойство("Показатели") Тогда
		Если ЗаполняемыеНастройки.Показатели Тогда
			// Управление показателями
			Отчет.ПоказательБУ            = Истина;
			//Отчет.ПоказательНУ            = Ложь;
			//Отчет.ПоказательПР            = Ложь;
			//Отчет.ПоказательВР            = Ложь;
			//Отчет.ПоказательКонтроль      = Ложь;
			Отчет.ПоказательВалютнаяСумма = Отчет.Счет.Валютный;
			Отчет.ПоказательКоличество    = Отчет.Счет.Количественный;
			Отчет.ПоказательКрахмал    = Отчет.Счет.Крахмал;
		КонецЕсли;
	КонецЕсли;

	Если ЗаполняемыеНастройки.Свойство("Группировка") Тогда
		Если ЗаполняемыеНастройки.Группировка Тогда
			// Добавление группировок с соответствии с выбранным счетом	
			Отчет.Группировка.Очистить();
			
			Если Отчет.Счет.УчетПоПодразделениям Тогда
				НоваяСтрока = Отчет.Группировка.Добавить();
				НоваяСтрока.Поле           = "Подразделение";
				НоваяСтрока.Использование  = Ложь;
				НоваяСтрока.Представление  = "Подразделение";
				НоваяСтрока.ТипГруппировки = 0;	
			КонецЕсли;
			
			Для Индекс = 1 По КоличествоСубконто Цикл
				НоваяСтрока = Отчет.Группировка.Добавить();
				Поле = Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс));
				НоваяСтрока.Поле           = Поле.Поле;
				НоваяСтрока.Использование  = Ложь;
				НоваяСтрока.Представление  = Поле.Заголовок;
				НоваяСтрока.ТипГруппировки = 0;	
				
				Если Отчет.Счет.Валютный Тогда
					НоваяСтрока = Отчет.Группировка.Добавить();
					НоваяСтрока.Поле = "Валюта";
					НоваяСтрока.Использование = Ложь;
					НоваяСтрока.Представление = "Валюта";
					НоваяСтрока.ТипГруппировки = 0;
				КонецЕсли;
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
				Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
					ОтборыДляУдаления.Добавить(ЭлементОтбора);
				КонецЕсли;	
				
			КонецЦикла;
			
			Для Каждого ЭлементОтбора Из ОтборыДляУдаления Цикл
				Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
			КонецЦикла;
			
			Для Индекс = 1 По КоличествоСубконто Цикл
				СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(Отчет.КомпоновщикНастроек, ИмяПоляПрефикс + Индекс, Отчет.Счет.ВидыСубконто[Индекс - 1].ВидСубконто.ТипЗначения.ПривестиЗначение(Неопределено), , Ложь);	
			КонецЦикла;
			Если Отчет.Счет.Валютный Тогда
				Поле = Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Валюта"));
				СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(Отчет.КомпоновщикНастроек, "Валюта", Поле.Тип.ПривестиЗначение(Неопределено), , Ложь); 
			КонецЕсли;
			
			Если Не Отчет.Счет.УчетПоПодразделениям Тогда
				Подразделение = Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	//заполняем пользовательские отборы. Добавил 02.11.12. d11
	УЧ_Сервер.ЗаполнитьОтборыВСтандартныхОтчетах(Отчет, КоличествоСубконто)	


	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Попытка
		ДанныеСчета = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Форма.Отчет.Счет);
	Исключение
		Форма.Отчет.Счет = ПредопределенноеЗначение("ПланСчетов.Учетный.ПустаяСсылка");
		ДанныеСчета = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Форма.Отчет.Счет);
		Форма.ОбновитьОтображениеДанных();
	КонецПопытки;
	
	//Форма.Элементы.ПоказательНУ.Доступность            = ДанныеСчета.НалоговыйУчет;
	//Форма.Элементы.ПоказательПР.Доступность            = ДанныеСчета.НалоговыйУчет;
	//Форма.Элементы.ПоказательВР.Доступность            = ДанныеСчета.НалоговыйУчет;
	//Форма.Элементы.ПоказательКонтроль.Доступность      = ДанныеСчета.НалоговыйУчет;
	Форма.Элементы.ПоказательВалютнаяСумма.Доступность = ДанныеСчета.Валютный;
	Форма.Элементы.ПоказательКоличество.Доступность    = ДанныеСчета.Количественный;
	Форма.Элементы.ПоказательКрахмал.Доступность    = ДанныеСчета.Крахмал;
	
	Форма.Отчет.ПоказательКрахмал = Ложь;
	
	Форма.Элементы.РазвернутоеСальдо.Доступность = (ДанныеСчета.Вид = ВидСчета.АктивноПассивный);
	
	//СтандартныеОтчетыКлиентСервер.ОбновитьПредставлениеПериода(Форма, Форма.Отчет.НачалоПериода, Форма.Отчет.КонецПериода);
	
КонецПроцедуры

&НаСервере
Процедура  ОбновитьВалютныйУчет()
	
	Если Отчет.Счет.Валютный и Отчет.Организация.ВедетсяВалютныйУчет Тогда
		Отчет.ПоказательВалютнаяСумма = Истина;
	КонецЕсли;
	
КонецПроцедуры 
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	СформироватьОтчетСервер();
	ОбновитьТекстЗаголовка(ЭтаФорма);

	
	ПроверитьВыполнениеЗадания();
	ПодключитьОбработчикОжидания("ПроверитьВыполнениеЗадания", 0.1, Истина);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеЗадания()
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			Заголовок = СтрЗаменить(Заголовок, " (формируется...)", "");
			УправленческиеОтчетыКлиентСервер.СкрыватьНастройкиПриФормированииОтчета(ЭтаФорма);
			Элементы.ПанельНастроек.Пометка = Элементы.ГруппаПанельНастроек.Видимость;
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
			Заголовок = СтрЗаменить(Заголовок, " (формируется...)", "");
			Заголовок = Заголовок + " (формируется...)";
			ПодключитьОбработчикОжидания("ПроверитьВыполнениеЗадания", 0.1, Истина);
		КонецЕсли;
	Исключение
		ЗагрузитьПодготовленныеДанные();
		Заголовок = СтрЗаменить(Заголовок, " (формируется...)", "");
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	КонецПопытки;	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	Если Не ЗначениеЗаполнено(АдресХранилища) Тогда
		Возврат;	
	КонецЕсли; 
	СтруктураПараметровОтчета = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат = СтруктураПараметровОтчета.Результат;
	//БухгалтерскийУчетПовтИсп.ВывестиОтчет(СтруктураПараметровОтчета.ОтчетОбъект, Результат, ДанныеРасшифровки, СхемаКомпоновкиДанных, Истина);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ПанельНастроек(Команда)
	
	Элементы.ГруппаПанельНастроек.Видимость = Не Элементы.ГруппаПанельНастроек.Видимость;
	Элементы.ПанельНастроек.Пометка = Элементы.ГруппаПанельНастроек.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	СчетПриИзмененииСервер();
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
		
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Отчет.Счет = БюджетныйНаСервере.ПолучитьДоступныйСчет(Отчет.Счет);
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
	ОбновитьВалютныйУчет();	 
	Отчет.ЭквивалентнаяВалюта = БюджетныйНаСервере.ВернутьРеквизит(Отчет.Организация, "ОсновнаяВалютаУчета");

	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ПОКАЗАТЕЛИ

&НаКлиенте
Процедура ПоказательБУПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательНУПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательПРПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВРПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательКонтрольПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВалютнаяСуммаПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательКоличествоПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутоеСальдоПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ГРУППИРОВКА

&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)

	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПоСубсчетамПриИзменении(Элемент)

	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	СтандартныеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	СтандартныеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ООСНОВНЫЕ НАСТРОЙКИ

&НаКлиенте
Процедура ЭквивалентнаяВалютаПриИзменении(Элемент)
	
	ПользовательскиеНастройкиМодифицированы = Истина;	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	СтандартныеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	СтандартныеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ДОПОЛНИТЕЛЬНЫЕ ПОЛЯ

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	СтандартныеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	СтандартныеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ КОР. ГРУППИРОВКА

&НаКлиенте
Процедура ПоСубсчетамКорСчетовПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаКорПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаКорПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамГруппировкаПередНачаломДобавления(ЭтаФорма, "ГруппировкаКор", Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаКорСчетПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамСчетПриИзменении(ЭтаФорма, "ГруппировкаКор", Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаКорПоСубсчетамПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПоСубсчетамПриИзменении(ЭтаФорма, "ГруппировкаКор", Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаКорПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеНачалоВыбора(ЭтаФорма, "ГруппировкаКор", Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаКорПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеОчистка(ЭтаФорма, "ГруппировкаКор", Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаКорПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартныеОтчетыКлиент.ТабличноеПолеПоСчетамПредставлениеОбработкаВыбора(ЭтаФорма, "ГруппировкаКор", Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаКорСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ГруппировкаКор Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаКорУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ГруппировкаКор Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ СОРТИРОВКА

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	СтандартныеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	СтандартныеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОФОРМЛЕНИЕ

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Элементы.Результат.Видимость = НЕ Константы.ЗадержкаОткрытияОтчетовРасшифровок.Получить();		                                             
	
	УправленческийУчетПовтИсп.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Свойство("ИДРасшифровки") Тогда
		БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
	//++ д1 ограничения на выбор счета
	УЧ_Сервер.ДобавитьОграничениеВыбораСчета(ЭтаФорма, "Счет");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отчет.НачалоПериода = Отчет.Период.ДатаНачала;
	Отчет.КонецПериода  = Отчет.Период.ДатаОкончания;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Отчет.РежимРасшифровки Тогда
		ПроверитьВыполнениеЗадания();
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеЗадания", 0.1, Истина);
		
		Если НЕ Элементы.Результат.Видимость Тогда
			ПодключитьОбработчикОжидания("ОтобразитьРезультат", 0.1, Истина);
		КонецЕсли; 
	КонецЕсли;
	
	Элементы.ПанельНастроек.Пометка = Элементы.ГруппаПанельНастроек.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьРезультат()
	Элементы.Результат.Видимость = Истина;
КонецПроцедуры
 

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ВариантМодифицирован                    = Ложь;
	//ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	УправленческийУчетПовтИсп.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	УправленческийУчетПовтИсп.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	//заполняем пользовательские отборы. Добавил 02.11.12. d11
	Попытка
		КоличествоСубконто = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет).КоличествоСубконто;
	Исключение
		Отчет.Счет = ПланыСчетов.Учетный.ПустаяСсылка();
		КоличествоСубконто = УправленческийУчетПовтИсп.ПолучитьСвойстваСчета(Отчет.Счет).КоличествоСубконто;
	КонецПопытки;
		
	УЧ_Сервер.ЗаполнитьОтборыВСтандартныхОтчетах(Отчет, КоличествоСубконто);	
	
	
	ИзменениеСхемыКомпоновкиДанных();
	
	УправлениеФормой(ЭтаФорма);
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
	ДобавитьНаправлениеКГруппировке();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	Отчет.НачалоПериода = Отчет.Период.ДатаНачала;
	Отчет.КонецПериода = Отчет.Период.ДатаОкончания;
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПоказательКрахмалПриИзменении(Элемент)
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	ИтогоСумма = Формат(БюджетныйНаКлиенте.Просуммировать(Результат), "ЧДЦ=2");
	
	
КонецПроцедуры

&НаКлиенте
Процедура Сумма(Команда)
    БюджетныйНаКлиенте.КопироватьВБуфер(ИтогоСумма);
КонецПроцедуры

&НаСервере
Процедура ДобавитьНаправлениеКГруппировке()
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	ДоступныеНаправления = ПараметрыСеанса.ДоступныеНаправления;
	//ДоступноБолееОдногоНаправления = ?(ДоступныеНаправления.Количество() > 1 Или ДоступныеНаправления.Найти(Справочники.НаправленияДеятельности.Общее) <> Неопределено, Истина, Ложь);
										
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ОсновныеДолжностиПредприятия.Предприятие
	               |ИЗ
	               |	РегистрСведений.ОсновныеДолжностиПредприятия КАК ОсновныеДолжностиПредприятия
	               |ГДЕ
	               |	ОсновныеДолжностиПредприятия.Сотрудник = &Пользователь";
	ДоступныеПредприятия = Запрос.Выполнить().Выгрузить();
	ДоступноБолееОдногоПредприятия = Не ТекущийПользователь.ДоступныПредприятияИзСписка Или ?(ДоступныеПредприятия.Количество() > 1, Истина, Ложь);
	
	Если ДоступноБолееОдногоПредприятия И Отчет.Группировка.НайтиСтроки(Новый Структура("Поле", "Организация")).Количество() = 0 тогда
		НоваяГруппировка = Отчет.Группировка.Вставить(0);
		НоваяГруппировка.Использование = Ложь;
		НоваяГруппировка.Поле          = "Организация";
		НоваяГруппировка.Представление = "Предприятие";
	КонецЕсли;
	
	//Если ДоступноБолееОдногоНаправления И Отчет.Группировка.НайтиСтроки(Новый Структура("Поле", "Организация.НаправлениеДеятельности")).Количество() = 0 тогда
	//	НоваяГруппировка = Отчет.Группировка.Вставить(0);
	//	НоваяГруппировка.Использование = Ложь;
	//	НоваяГруппировка.Поле          = "Организация.НаправлениеДеятельности";
	//	НоваяГруппировка.Представление = "НаправлениеДеятельности";
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПриИзменении(Элемент)
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;

КонецПроцедуры

&НаКлиенте
Процедура УсловноеОформлениеПриИзменении(Элемент)
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	БюджетныйНаКлиенте.ОтправитьПоЭлектроннойПочтеКлиент(ЭтаФорма, Элементы);
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	Расшифровка = Неопределено;
	
КонецПроцедуры

