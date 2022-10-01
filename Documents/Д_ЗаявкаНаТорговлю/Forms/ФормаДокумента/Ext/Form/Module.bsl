﻿///////////////////////////////////общие процедуры и функции
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//если уже есть БП по документу, то не отражаем кнопки запуска БП
		
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекБП = БПСервер.НайтиТекущийБПСервер(Объект.Ссылка);
		Если НЕ ТекБП = Неопределено Тогда
			ТекБПСтруРекв = БюджетныйНаСервере.ВернутьРеквизиты(ТекБП, "ОснованиеЗаблокирован, Стартован, ОтправлятьВсем");
		КонецЕсли;
	Иначе
		ТекБП = Неопределено;
		ТекБПСтруРекв = Новый Структура;
		ВсемСразу = Неопределено;
	КонецЕсли;
	
	Если НЕ БюджетныйНаСервере.РольДоступнаСервер("Администратор") И НЕ ТекБП = Неопределено Тогда
		ТекДоступность = ТекБПСтруРекв.ОснованиеЗаблокирован;
		Если ТекДоступность = Неопределено Тогда
			ТекДоступность = ТекБПСтруРекв.Стартован;
		КонецЕсли;
		БюджетныйНаКлиенте.ФормаТолькоПросмотр(Объект, ЭтаФорма, ТекДоступность);
		Элементы.ФормаДокументСогласовать.Заголовок = "Отправить и закрыть";
		//Если ЗначениеЗаполнено(ТекБП) Тогда
		//	Элементы.ДобавитьКому.Доступность = 1 - ТекДоступность;
		//	Элементы.ФормаДокументСогласовать.Доступность = 1 - ТекДоступность;
		//КонецЕсли;
	КонецЕсли;
	
	//Элементы.ВидимостьВсем.Заголовок = "Доступен пользователям предприятиия: " + Строка(Объект.Предприятие);
	ПредприятиеПриИзменении(Неопределено);

	ЦенаПриИзменении(0);
	
	ВидЗакупкиПриИзменении(0);
	
	Если Не РежимВосстановления Тогда
		ЭтаФорма.ПодключитьОбработчикОжидания("АвтосохранениеРеквизитовФормыНаКлиенте", 30);
	КонецЕсли;
	
	
	//формируем красивые списки
	ДоступныеПредприятия = БюджетныйНаСервере.ПолучитьПредприятия();
	Если ДоступныеПредприятия.Количество() < 15 Тогда
		БюджетныйНаКлиенте.ЗаполнитьСписокРеквизитаДубль2(ЭтаФорма, "СписокВыбора_Предприятие", ДоступныеПредприятия, Объект.Предприятие);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Автор = БюджетныйНаСервере.ПолучитьПользователя();
		Если ПустаяСтрока(Объект.Контрагент) Тогда
			Объект.Контрагент = ПустойКонтрагент();	
		КонецЕсли;
		
		Объект.ОтветственноеЛицо = ПустойПользователь();
		Объект.КонтактноеЛицо = ПустойПользователь();
		
		Объект.ЦенаНДС = БезНДС();
		Объект.ТранспортныеРасходыНДС = БезНДС();
		Объект.ВерхНДС = БезНДС();
		Объект.ПрочиеРасходыНДС = БезНДС();		
	КонецЕсли;	
	
	ПериодПоставки.ДатаНачала = Объект.ДатаПоставкиНач;
	ПериодПоставки.ДатаОкончания = Объект.ДатаПоставкиКон;	
	
	сабОбщегоНазначения.ОбновитьКоличествоПрикрепленныхФайловСервер(ЭтаФорма);
	Если Параметры.Свойство("РежимВосстановления") и Параметры.РежимВосстановления Тогда
		сабОбщегоНазначения.ВосстановлениеРеквизитовФормы(ЭтаФорма);
		РежимВосстановления = Истина;
	Иначе 
		РежимВосстановления = Ложь;
	КонецЕсли;
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, Новый Структура("Объект, ИмяЭлементаДляРазмещения", Объект, "ГруппаДополнительныеРеквизиты"));
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Объект.Комментарий = Объект.ВидТрейдинга + " " + Строка(Объект.Номенклатура) + " " + Строка(Объект.ФизическийОбъем) + "/" + Строка(Объект.Цена);	
	Отказ = 1 - ПроверитьЗаполнение();
	сабОбщегоНазначения.ОчиститьАвтосохраненияОбъекта(Объект.Ссылка);
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьКому(Команда)
	Если НЕ Объект.Рецензенты.Количество() И НЕ ПустаяСтрока(Объект.Кому) И ТипЗнч(Объект.Кому) = Тип("СправочникСсылка.Пользователи") Тогда
		НоваяСтрока = Объект.Рецензенты.Добавить();
		НоваяСтрока.Пользователь = Объект.Кому;
	КонецЕсли;
	
	ТекПользователь = ОткрытьФормуМодально("Справочник.Пользователи.ФормаВыбора");
	Если НЕ ТекПользователь = Неопределено Тогда
		
		НетВБазе = БюджетныйНаСервере.ВернутьРеквизит(ТекПользователь, "НеУчаствуетВДокументообороте");
		Если НетВБазе Тогда
			Если Вопрос("Пользователь " + Строка(ТекПользователь) + " не участвует в документообороте, т.к. не имеет доступа к базе. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
				Возврат;	
			КонецЕсли;	
		КонецЕсли;	
		
		НоваяСтрока = Объект.Рецензенты.Добавить();
		НоваяСтрока.Пользователь = ТекПользователь;
	Иначе
		Возврат;
	КонецЕсли;
	СформироватьКому(ТекПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура КомуПриИзменении(Элемент)
	//Проверяем пользователей по наименованию. разделитель ;
	Если ТипЗнч(Объект.Кому) = Тип("Строка") И НЕ ПустаяСтрока(Объект.Кому) Тогда
		ТекСтрока = СтрЗаменить(Объект.Кому, "; ", ";");
		МассивИмен = Новый Массив;
		ТекИмя = "";
		Для ТекСимвол = 1 По СтрДлина(ТекСтрока) Цикл
			
			Если Сред(ТекСтрока, ТекСимвол, 1) = ";" Тогда
				МассивИмен.Добавить(ТекИмя);
				ТекИмя = "";
			Иначе
				ТекИмя = ТекИмя + Сред(ТекСтрока, ТекСимвол, 1);			
			КонецЕсли;	
			
		КонецЦикла;
		МассивИмен.Добавить(ТекИмя);
		Для каждого ТекИмя Из МассивИмен Цикл	
			Если НайтиИмя(ТекИмя) = Неопределено Тогда
				Предупреждение("Пользователь " + Строка(ТекИмя) + " не найден в справочнике.");
				СформироватьКому();
				Возврат;
			КонецЕсли;		
		КонецЦикла;
		СформироватьТЧ(МассивИмен);
	Иначе
		НетВБазе = БюджетныйНаСервере.ВернутьРеквизит(Объект.Кому, "НеУчаствуетВДокументообороте");
		Если НетВБазе Тогда
			Если Вопрос("Пользователь " + Строка(Объект.Кому) + " не участвует в документообороте, т.к. не имеет доступа к базе. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
				Объект.Кому = ПользовательПустаяСсылка();
				Возврат;	
			КонецЕсли;	
		КонецЕсли;	
		
	КонецЕсли;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьКому(ТекПользователь = Неопределено)
	
	//Если Объект.Рецензенты.Количество() > 1 Тогда
	//	СтрокаКому = "";
	//	Для каждого ТекРецензент Из Объект.Рецензенты Цикл
	//		СтрокаКому = СтрокаКому + Строка(ТекРецензент.Пользователь) + "; ";		
	//	КонецЦикла;
	//	СтрокаКому = Лев(СтрокаКому, СтрДлина(СтрокаКому) - 2);
	//	Объект.Кому = СтрокаКому;
	//Иначе
	//	Если НЕ ТекПользователь = Неопределено Тогда
	//		Объект.Кому = ТекПользователь;
	//	КонецЕсли;
	//КонецЕсли;
	
	Если Элементы.ДобавитьКому.Видимость Тогда
		СтрокаКому = "";
		Для каждого ТекРецензент Из Объект.Рецензенты Цикл
			СтрокаКому = СтрокаКому + Строка(ТекРецензент.Пользователь) + "; ";		
		КонецЦикла;
		СтрокаКому = Лев(СтрокаКому, СтрДлина(СтрокаКому) - 2);
		Объект.Кому = СтрокаКому;
	Иначе
		Объект.Кому = ТекПользователь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТЧ(МассивИмен)
	Объект.Рецензенты.Очистить();
	Для каждого ТекПользователь Из МассивИмен Цикл
		НоваяСтрока = Объект.Рецензенты.Добавить();
		НоваяСтрока.Пользователь = НайтиИмя(ТекПользователь);	
	КонецЦикла; 
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиИмя(ТекИмя)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Пользователи.Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", ТекИмя);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции // ()

&НаКлиенте
Процедура КомуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Объект.Кому = "" И Элементы.ДобавитьКому.Видимость = Ложь Тогда
		Объект.Кому = ПользовательПустаяСсылка();
	КонецЕсли;	
		
	Если ТипЗнч(Объект.Кому) = Тип("Строка") Тогда
		СтандартнаяОбработка = Ложь;
		МассивСтарыхРецензентов = Новый Массив;
		Для каждого ТекРецензент Из Объект.Рецензенты Цикл
			МассивСтарыхРецензентов.Добавить(ТекРецензент.Пользователь);		
		КонецЦикла; 
		
		МассивРецензентов = ОткрытьФормуМодально("Документ.Д_СлужебнаяЗаписка.Форма.ФормаРецензенты", Новый Структура("Рецензенты", МассивСтарыхРецензентов));
		Если НЕ МассивРецензентов = Неопределено Тогда
			Объект.Рецензенты.Очистить();
			Для каждого ТекРецензент Из МассивРецензентов Цикл
				НоваяСтрока = Объект.Рецензенты.Добавить();
				НоваяСтрока.Пользователь = ТекРецензент;			
			КонецЦикла;
			СформироватьКому();
		КонецЕсли;
	ИначеЕсли Объект.Кому = Неопределено Тогда
		Объект.Кому = ПользовательПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомуОчистка(Элемент, СтандартнаяОбработка)
	Объект.Рецензенты.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	//Элементы.ВидимостьВсем.Заголовок = "Доступен пользователям предприятиия: " + Строка(Объект.Предприятие);
	
	СтруктураДанных = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Предприятие, "УчетПоПодразделениям, ВидДеятельности"); 
	
	Если НЕ СтруктураДанных = Неопределено Тогда
		Элементы.Подразделение.Доступность = СтруктураДанных.УчетПоПодразделениям;
		Если НЕ Элемент = Неопределено Тогда 
			Если СтруктураДанных.УчетПоПодразделениям Тогда
				Объект.Подразделение = СтруктураДанных.ВидДеятельности;
			Иначе
				Объект.Подразделение = "";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если СписокВыбора_Предприятие.Количество() Тогда
		ТекЗначение = ВыбратьИзСписка(СписокВыбора_Предприятие, Элемент, СписокВыбора_Предприятие.НайтиПоЗначению(Объект.Предприятие));	
		БюджетныйНаКлиенте.ПриНачалеВыбораРеквизитаВСпискеДубль2(ЭтаФорма, "СписокВыбора_Предприятие", ТекЗначение, "Предприятия", Объект.Предприятие, СтандартнаяОбработка, Ложь);
		ПредприятиеПриИзменении(Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытьФорму" Тогда
		//ЭтаФорма.Записать();
		ЭтаФорма.Закрыть();
	ИначеЕсли ИмяСобытия = "УстановитьДоступность" Тогда
		Объект.ТекущийБизнесПроцесс = Параметр.ТекущийБизнесПроцесс;
		Записать();
	ИначеЕсли ИмяСобытия = "Пересчитать" Тогда
		Закрыть();
	ИначеЕсли ИмяСобытия = "ПрикрепленныеФайлы" Тогда	
		сабОбщегоНазначенияКлиент.ОбновитьКоличествоПрикрепленныхФайлов(ЭтаФорма);
	ИначеЕсли ИмяСобытия = "РазрешитьРедактированиеФормы" Тогда	
		ПриОткрытии(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	сабОбщегоНазначенияКлиент.ПослеЗаписиАвтосохраняемойФормы(ЭтаФорма);
КонецПроцедуры

&НаСервереБезКонтекста
Функция  ПользовательПустаяСсылка()
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции

&НаКлиенте
Процедура АвтосохранениеРеквизитовФормыНаКлиенте()
	
	Если НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
		
	АвтосохранениеРеквизитовФормыНаСервере();		
	
КонецПроцедуры

&НаСервере 
Процедура АвтосохранениеРеквизитовФормыНаСервере()
	
	сабОбщегоНазначения.АвтосохранениеРеквизитовФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если НЕ ЗавершениеРаботы И Не РежимВосстановления Тогда
		сабОбщегоНазначения.ОчиститьАвтосохраненияОбъекта(Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если СписокВыбора_Подразаделение.Количество() Тогда
		ТекЗначение = ВыбратьИзСписка(СписокВыбора_Подразаделение. Элемент, СписокВыбора_Подразаделение.НайтиПоЗначению(Объект.Подразделение));	
		БюджетныйНаКлиенте.ПриНачалеВыбораРеквизитаВСпискеДубль2(ЭтаФорма, "СписокВыбора_Подразаделение", ТекЗначение, "ВидыДеятельности", Объект.Подразделение, СтандартнаяОбработка, Ложь);
	КонецЕсли;

КонецПроцедуры

////////////////////конец общих процедур и функций




&НаСервереБезКонтекста
Функция БезНДС()
	Возврат Справочники.СтавкиНДС.НайтиПоНаименованию("Без НДС", Истина);
КонецФункции

&НаСервереБезКонтекста
Функция ПустойКонтрагент()

	Возврат Справочники.Контрагенты.ПустаяСсылка();	

КонецФункции // ()

&НаСервереБезКонтекста
Функция ПустойПользователь()
	Возврат Справочники.Пользователи.ПустаяСсылка();
КонецФункции // ()
 

&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	ЧистаяЦена = Объект.Цена + Объект.Верхи + Объект.ТранспортныеРасходы + Объект.ПрочиеРасходы;
	
	//Элементы.Группа6.Заголовок = "Итоговая цена: " + Формат(ЧистаяЦена, "ЧДЦ=2") + " руб/т";
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВернутьПеречисоениеДолжность(ДолжностьСтрока)
	
	Возврат Перечисления.ОсновныеДолжностиПредприятия[ДолжностьСтрока];

	

КонецФункции // ()

&НаСервере
Функция ПолучитьОтветственного()
	Возврат Справочники.Пользователи.ПустаяСсылка();	//нужно исправить!!! на основную должость предприятия
 КонецФункции // ()
  

&НаКлиенте
Процедура ДокПриИзменении(Элемент)
		Объект.УчетчикДоки = БюджетныйНаСервере.ВернутьРеквизит(Объект.Док, "Учетчик");
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПоискТрат(Ссылка)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Д_СогласованиеТрат.Ссылка
	|ИЗ
	|	Документ.Д_СогласованиеТрат КАК Д_СогласованиеТрат
	|ГДЕ
	|	Д_СогласованиеТрат.ДокОснование = &ДокОснование";
	
	Запрос.УстановитьПараметр("ДокОснование", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Возврат Выборка.Следующий();
	
	
КонецФункции // ()

	
&НаСервере
Процедура ЗаписатьВАрхив()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	*
	               |ИЗ
	               |	Документ.Д_ЗаявкаНаТорговлю КАК Д_ЗаявкаНаЗакупкуСырья
	               |ГДЕ
	               |	Д_ЗаявкаНаЗакупкуСырья.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.АрхивЗаявок.Добавить();
		НоваяСтрока.ДатаАрхивации = ТекущаяДата();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
КонецПроцедуры // ()
 

&НаКлиенте
Процедура ИсторияДокумента(Команда)
	ТабДок = Новый ТабличныйДокумент;
	БПСервер.ПечатьИсторииЗаявкиЗакупки(ТабДок, Объект.Ссылка);

	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.АвтоМасштаб = Истина;
	
	ТабДок.Показать();
КонецПроцедуры


 Процедура УдалитьБПИЗадачи(Ссылка, ВидДокумента)
	//Если Ссылка.ПометкаУдаления Тогда //при удалении бизнес-процесса удаляем задачи
	
	//удаляем БП
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаявкиНаОтгрузку.Ссылка
	               |ИЗ
	               |	БизнесПроцесс." + ВидДокумента + " КАК ЗаявкиНаОтгрузку
	               |ГДЕ
	               |	ЗаявкиНаОтгрузку.Заявка = &Заявка";
	
	Запрос.УстановитьПараметр("Заявка", Ссылка);
	
	Результат = Запрос.Выполнить();
	ВыборкаЗадачи = Результат.Выбрать();
	
	Пока ВыборкаЗадачи.Следующий() Цикл
		ТекБП = ВыборкаЗадачи.Ссылка.ПолучитьОбъект();
		ТекБП.Удалить();
	КонецЦикла;
	
	//удаляем задачи
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	Задача.Ссылка
				   |ИЗ
				   |	Задача.Задача КАК Задача
				   |ГДЕ
				   |	Задача.Заявка = &Заявка";
	
	Запрос.УстановитьПараметр("Заявка", Ссылка);
	
	Результат = Запрос.Выполнить();
	ВыборкаЗадачи = Результат.Выбрать();
	
	Пока ВыборкаЗадачи.Следующий() Цикл
		ТекБП = ВыборкаЗадачи.Ссылка.ПолучитьОбъект();
		ТекБП.Удалить();
	КонецЦикла;
	Объект.ТекущаяЗадача = "";
	Объект.ТекущийБизнесПроцесс = "";
КонецПроцедуры

&НаКлиенте
Процедура ВидДоставкиПриИзменении(Элемент)
	Если Объект.ВидДоставки = "Жд" Тогда
		Объект.Водитель = "";
		Элементы.Водитель.Доступность = Ложь;
	Иначе
		Элементы.Водитель.Доступность = Истина;	
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьДЗ(Команда)
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьЗадачуСогласования(СтруктураКонтрагента, ТекПредприятие)
	НачатьТранзакцию();
	Задача = Задачи.Задача.СоздатьЗадачу();		
	Задача.Заявка = Справочники.Контрагенты.ПустаяСсылка();
	Задача.Дата = ТекущаяДата();
	Задача.Наименование = "Согласовать нового контрагента: " + Строка(СтруктураКонтрагента.Наименование);
	Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	Задача.Комментарии = СтруктураКонтрагента.Наименование;
	Задача.Описание = "ИНН: " + ?(СтруктураКонтрагента.Учетный, "Учетный", СтруктураКонтрагента.ИНН) + "# " + СтруктураКонтрагента.Описание;;
	Задача.Предприятие = СтруктураКонтрагента.Предприятие;
	Задача.Исполнитель = ОбщегоНазначения.ПолучитьОтветственногоЗаСправочник(Перечисления.ТипыПроверяемыхСправочников.Контрагенты);
	Если СтруктураКонтрагента.КонтрагентЯвляетсяПокупателем Тогда //если контрагент-покупатель
		НоваяСтрока = Задача.ПараметрыЗадачи.Добавить();
		НоваяСтрока.Параметр = "ДатаОтветственный";
		НоваяСтрока.Значение = СтруктураКонтрагента.ДатаОтветственный;
		НоваяСтрока = Задача.ПараметрыЗадачи.Добавить();
		НоваяСтрока.Параметр = "Ответственный";
		НоваяСтрока.Значение = СтруктураКонтрагента.Ответственный;
		НоваяСтрока = Задача.ПараметрыЗадачи.Добавить();
		НоваяСтрока.Параметр = "ДатаКомДиректор";
		НоваяСтрока.Значение = СтруктураКонтрагента.ДатаКомДиректор;
		НоваяСтрока = Задача.ПараметрыЗадачи.Добавить();
		НоваяСтрока.Параметр = "КомДиректор";
		НоваяСтрока.Значение = СтруктураКонтрагента.КомДиректор;
	КонецЕсли;
	НоваяСтрока = Задача.ПараметрыЗадачи.Добавить();
	НоваяСтрока.Параметр = "ПолноеНаим";
	НоваяСтрока.Значение = СтруктураКонтрагента.ПолноеНаименование;
	Задача.Записать();
	ЗафиксироватьТранзакцию();
	Возврат Задача.Ссылка;
КонецФункции

&НаСервере
Процедура ЗаписатьКонтрагента(ТекКонтрагент, ТекПредприятие)
	
	ОбъектКонтрагент = ТекКонтрагент.ПолучитьОбъект();
	
	СтруктураПоиска = Новый Структура("Предприятие", ТекПредприятие);
	Если ОбъектКонтрагент.Предприятия.НайтиСтроки(СтруктураПоиска).Количество() тогда
		Сообщить("Предприятие " + Строка(ТекПредприятие) + " уже доступно.");
		//СтандартнаяОбработка = Ложь;
		Возврат;	
	КонецЕсли;	
	
	НоваяСтрока = ОбъектКонтрагент.Предприятия.Добавить();
	НоваяСтрока.Предприятие = ТекПредприятие;
	ОбъектКонтрагент.Записать();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонтрагента(Команда)
	
	ТекНовый = БюджетныйНаКлиенте.СоздатьКонтрагента();
	Если НЕ ТекНовый = Неопределено Тогда
		Объект.Контрагент = ТекНовый;
	КонецЕсли;
	
	ОповеститьОбИзменении(Тип("ЗадачаСсылка.Задача"));
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДопРеспондентов(ТекПП)
	МассивПП = Новый Массив;
	Для каждого ТекРеспондент Из ТекПП.ДопСписокРеспондентов Цикл
		Если ТекРеспондент.Признак = "Снаб" Тогда
			МассивПП.Добавить(ТекРеспондент.EMail);
		КонецЕсли;		
	КонецЦикла;
	Возврат МассивПП;
КонецФункции // ()

&НаКлиенте
Процедура ВидСырьяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//СтандартнаяОбработка = Ложь;
	//СписокВыбора = Новый СписокЗначений;
	//СписокВыбора.Добавить("Материалы");
	//СписокВыбора.Добавить("Строка (ручной ввод)");
	//
	//ТекЗнач = СписокВыбора.ВыбратьЭлемент("Выберите тип данных");
	//
	//Если НЕ ТекЗнач = Неопределено Тогда
	//	Если ТекЗнач.Значение = "Материалы" Тогда
	//		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбораСОстатками101", Новый Структура(
	//		"ТекущаяСтрока,
	//		|ВыбДата,
	//		|ВыбПредприятие,
	//		|ВыбПодразделение",
	//		Объект.Номенклатура,
	//		Объект.Дата,
	//		Объект.Предприятие,
	//		Объект.Подразделение,
	//		) , Элемент); 
	//	Иначе
	//		Объект.Номенклатура = "";
	//	КонецЕсли;
	//КонецЕсли;
	//
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОМЕ()
	Возврат Справочники.Пользователи.ОМЕ;
КонецФункции // ()

&НаКлиенте
Процедура ПериодПоставкиПриИзменении(Элемент)
	Объект.ДатаПоставкиНач = ПериодПоставки.ДатаНачала;
	Объект.ДатаПоставкиКон = ПериодПоставки.ДатаОкончания;
КонецПроцедуры

&НаКлиенте
Процедура ТипСырьяПриИзменении(Элемент)
	ВидЗерно = (Объект.ТипСырья = "зерно");
	Элементы.Сорность.Видимость = ВидЗерно;
	Элементы.Влажность.Видимость = ВидЗерно;
	Элементы.Крахмалистость.Заголовок = ?(Объект.ТипСырья = "патока", "Сахаристость", "Крахмалистость");
	//Элементы.СоответствуетГОСТ.Видимость = 1 - ВидЗерно;
	Элементы.ПараметрыПатоки.Видимость = 1 - ВидЗерно;
	Если НЕ Элемент = Неопределено И НЕ ВидЗерно Тогда
		Объект.Сорность = 0;
		Объект.Влажность = 0;
	Иначе
		Объект.ПараметрыПатоки = "";
	КонецЕсли;
	СоответствуетГОСТПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СоответствуетГОСТПриИзменении(Элемент)
	Элементы.ПараметрыПатоки.Доступность = 1 - Объект.СоответствуетГОСТ;
	Если НЕ Элемент = Неопределено И НЕ Объект.СоответствуетГОСТ Тогда
		Объект.ПараметрыПатоки = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидЗакупкиПриИзменении(Элемент)
	Элементы.Группа29.ТекущаяСтраница = Элементы.Группа31;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьУчетчика(Предприятие)
	Возврат БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(Предприятие, Перечисления.ОсновныеДолжностиПредприятия.Учетчик);
КонецФункции

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма);
КонецПроцедуры


&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма);
КонецПроцедуры

