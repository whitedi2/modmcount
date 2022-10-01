﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = "Отчет по проводкам" + СтандартныеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода);

	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + УправленческийУчетПовтИсп.ПолучитьТекстОрганизация(Отчет.Организация, ложь);
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
	
	Если Режим = "Отбор" Тогда
		Для Каждого ИмяПоказателя Из НаборПоказателей Цикл
			Если Не Отчет["Показатель" + ИмяПоказателя] Тогда
				СписокПолей.Добавить(ИмяПоказателя + "Дт");
				СписокПолей.Добавить(ИмяПоказателя + "Кт");
				Если ИмяПоказателя = "ВалютнаяСумма" Тогда
					СписокПолей.Добавить("Валюта");
					СписокПолей.Добавить("ВалютаДт");
					СписокПолей.Добавить("ВалютаКт");
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Процедура СформироватьОтчетСервер() Экспорт
	
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	
	Отч = РеквизитФормыВЗначение("Отчет");
	СтруктураПараметровОтчета = Новый Структура;
	СтруктураПараметровОтчета.Вставить("КомпоновщикНастроек", Неопределено);
	СтруктураПараметровОтчета.Вставить("КомпоновщикНастроекНастройки", Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	СтруктураПараметровОтчета.Вставить("ИмяОтчета", "сабОтчетПоПроводкам");
	//СтруктураПараметровОтчета.Вставить("Группировка", Отчет.Группировка.Выгрузить());
	//СтруктураПараметровОтчета.Вставить("ГруппировкаКор", Отчет.ГруппировкаКор.Выгрузить());
	//СтруктураПараметровОтчета.Вставить("Отчет", Отч);
	Для каждого ТекЭл Из Метаданные.Отчеты.сабОтчетПоПроводкам.Реквизиты Цикл
		СтруктураПараметровОтчета.Вставить(ТекЭл.Имя, Отчет[ТекЭл.Имя]);	
	КонецЦикла;
	НаборПоказателей2 = Новый Структура;
	НаборПоказателей2.Вставить("БУ", Метаданные.Отчеты.сабОтчетПоПроводкам.Реквизиты.ПоказательБУ.Синоним);
	НаборПоказателей2.Вставить("ВалютнаяСумма", Метаданные.Отчеты.сабОтчетПоПроводкам.Реквизиты.ПоказательВалютнаяСумма.Синоним);
	НаборПоказателей2.Вставить("Количество", Метаданные.Отчеты.сабОтчетПоПроводкам.Реквизиты.ПоказательКоличество.Синоним);
	НаборПоказателей2.Вставить("Крахмал", Метаданные.Отчеты.сабОтчетПоПроводкам.Реквизиты.ПоказательКрахмал.Синоним);
	//НаборПоказателей2.Вставить("Цена", Метаданные.Отчеты.сабАнализСчета.Реквизиты.ПоказательЦена.Синоним);
	//НаборПоказателей2.Вставить("Курс", Метаданные.Отчеты.сабАнализСчета.Реквизиты.ПоказательКурс.Синоним);
	СтруктураПараметровОтчета.Вставить("НаборПоказателей", НаборПоказателей2);
	СтруктураПараметровОтчета.Вставить("ИдентификаторОбъекта", "ОтчетОбъект.сабОтчетПоПроводкам");
	
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
	//сабОбщегоНазначения.ВывестиТиповойОтчет(ПараметрыОтчета, АдресХранилища);
	//ОбъектОтчет = РеквизитФормыВЗначение("Отчет");
	//ОбъектОтчет.СформироватьОтчет(Результат, ДанныеРасшифровки, СхемаКомпоновкиДанных, Истина);
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки) Экспорт
	
	Если ЗаполняемыеНастройки.Свойство("Показатели") Тогда
		Если ЗаполняемыеНастройки.Показатели Тогда
			// Управление показателями
			Отчет.ПоказательБУ            = Истина;
			//Отчет.ПоказательНУ            = Ложь;
			//Отчет.ПоказательПР            = Ложь;
			//Отчет.ПоказательВР            = Ложь;

			Отчет.ПоказательВалютнаяСумма = Ложь;
			Отчет.ПоказательКоличество    = Ложь;
			Отчет.ПоказательКрахмал    = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	//СтандартныеОтчетыКлиентСервер.ОбновитьПредставлениеПериода(Форма, Форма.Отчет.НачалоПериода, Форма.Отчет.КонецПериода);

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

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ВидПериодаПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиент.ВидПериодаПриИзменении(ЭтаФорма, Отчет.НачалоПериода, Отчет.КонецПериода, 
		ДоступныеПериодыОтчета.День);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Отчет.ЭквивалентнаяВалюта = БюджетныйНаСервере.ВернутьРеквизит(Отчет.Организация, "ОсновнаяВалютаУчета");
	 
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
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
Процедура ПоказательВалютнаяСуммаПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательКоличествоПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
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
	ПользовательскиеНастройкиМодифицированы = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;

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
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
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
	
	УправлениеФормой(ЭтаФорма);
	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
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
Процедура УсловноеОформлениеПриИзменении(Элемент)
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	ПользовательскиеНастройкиМодифицированы = Истина;

КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	Расшифровка = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭквивалентнаяВалютаПриИзменении(Элемент)
	
	ПользовательскиеНастройкиМодифицированы = Истина;	
	СтандартныеОтчетыКлиентСервер.УстановитьСостояние(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Сумма(Команда)
	
	БюджетныйНаКлиенте.КопироватьВБуфер(ИтогоСумма);

КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	ИтогоСумма = Формат(БюджетныйНаКлиенте.Просуммировать(Результат), "ЧДЦ=2");
	
КонецПроцедуры
