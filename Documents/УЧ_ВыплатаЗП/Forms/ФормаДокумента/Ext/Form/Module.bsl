﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзExcell(Команда)
	Если Объект.ТабличнаяЧасть.Количество()>0 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("Перед загрузкой данных табличная часть будет очищена. Продолжить?",Режим);			
		Если Ответ=КодВозвратаДиалога.Да Тогда
			Объект.ТабличнаяЧасть.Очистить();
			//СтруктураПараметров = Новый Структура("ТаблицаЗначений", Объект.ТабличнаяЧасть);
			ОткрытьФорму("Документ.УЧ_НачислениеЗП.Форма.Форма",,Элементы.ТабличнаяЧасть);
		КонецЕсли;
	Иначе 
		ОткрытьФорму("Документ.УЧ_НачислениеЗП.Форма.Форма",,Элементы.ТабличнаяЧасть);
	КонецЕсли; 	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка = Документы.УЧ_ВыплатаЗП.ПустаяСсылка() Тогда
		Объект.СчетСписания = ПланыСчетов.Учетный.Счет70()
	КонецЕсли;
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	Отказ = НЕ БюджетныйНаСервере.ПроверкаДоступностиЗП(Объект.Предприятие);
	Если Отказ Тогда
		Сообщить("Нет прав на открытие зарплатного документа.");	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Для каждого ТекСтрока Из Объект.ТабличнаяЧасть Цикл
		//Если ЗначениеЗаполнено(Объект.ЮрЛицо) Тогда
		//	ТекСтрока.ЮрЛицо = Объект.ЮрЛицо; 
		//КонецЕсли;
		Если НЕ Объект.НачислениеВРазрезеПредприятий Тогда
			ТекСтрока.Предприятие = Объект.Предприятие;	
			ТекСтрока.Подразделение = Объект.Предприятие;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.ВидНачисления) Тогда
			ТекСтрока.ВидНачисления = Объект.ВидНачисления; 
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ТекСтрока.Предприятие) Тогда
			
			Если Не БПСервер.ПолучитьКонстантуНаСервере("сабИспользоватьНесколькоПредприятий") Тогда
				ТекСтрока.Предприятие = БюджетныйНаСервере.ПолучитьПредприятие();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не БПСервер.ПолучитьКонстантуНаСервере("сабИспользоватьНесколькоПредприятий") Тогда
		Элемент.ТекущиеДанные.Предприятие = БюджетныйНаСервере.ПолучитьПредприятие();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	ПредприятиеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПредприятиеПриИзмененииНаСервере()
	сабОбщегоНазначенияКлиентСервер.СкрытьПодразделения(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыплату(Команда)
	
	ТекДанные = Элементы.ТабличнаяЧасть.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекДанные.ДокументВыплаты) Тогда
		Сообщить("Документ выплаты уже создан для данной строки.");
		Возврат;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда
		СоздатьВыплатуЗавершение(КодВозвратаДиалога.Да, Новый Структура("ТекДанные, Записать", ТекДанные, Ложь));
	Иначе
		ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьВыплатуЗавершение", ЭтотОбъект, Новый Структура("ТекДанные, Записать", ТекДанные, Истина)), "Документ должен быть записан. Записать?", РежимДиалогаВопрос.ДаНет);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыплатуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.Записать Тогда
		Если Объект.Проведен Тогда
			Записать(РежимЗаписиДокумента.Проведение);	
		Иначе
			Записать();	
		КонецЕсли;		
	КонецЕсли;
	
	ТекДанные = ДополнительныеПараметры.ТекДанные;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да  Тогда
		СтруктураПараметров = Новый Структура("Основание", Новый Структура("ДокументВыплаты, Сотрудник, ВидНачисления, Сумма, Комментарий, Подразделение", 
		Объект.Ссылка, ТекДанные.Сотрудник, ТекДанные.ВидНачисления, ТекДанные.Сумма, ТекДанные.Комментарий, ТекДанные.Подразделение));
		ОткрытьФорму("Документ.УЧ_ДвижениеДС.ФормаОбъекта", СтруктураПараметров, ЭтаФорма,,,,Новый ОписаниеОповещения("ПослеЗаписиДС", ЭтотОбъект, СтруктураПараметров) ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиДС(Результат, ДополнительныеПараметры) Экспорт
	ДополнительныеПараметры.Вставить("Ссылка", Объект.Ссылка);
	СтруктураВыплаты = ЗаполнитьСтрокуДокументомВыплаты(ДополнительныеПараметры);
	Если Не СтруктураВыплаты = Неопределено Тогда
		Элементы.ТабличнаяЧасть.ТекущиеДанные.ДокументВыплаты = СтруктураВыплаты.Документ;
		Элементы.ТабличнаяЧасть.ТекущиеДанные.СуммаВыплачено = СтруктураВыплаты.СуммаДокумента;
		Записать(); //фиксируем результат
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСтрокуДокументомВыплаты(ДополнительныеПараметры)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УЧ_ДвижениеДС.Ссылка КАК Ссылка,
	               |	УЧ_ДвижениеДС.СуммаДокумента КАК СуммаДокумента
	               |ИЗ
	               |	Документ.УЧ_ДвижениеДС КАК УЧ_ДвижениеДС
	               |ГДЕ
	               |	УЧ_ДвижениеДС.ДокОснование = &ДокОснование
	               |	И УЧ_ДвижениеДС.Проводки.КорСубконто1 = &КорСубконто1
	               |	И УЧ_ДвижениеДС.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("ДокОснование", ДополнительныеПараметры.Ссылка);
	Запрос.УстановитьПараметр("КорСубконто1", ДополнительныеПараметры.Основание.Сотрудник);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Новый Структура("Документ, СуммаДокумента", Выборка.Ссылка, Выборка.СуммаДокумента);		
	КонецЦикла;
	
	Возврат Неопределено;

КонецФункции

#Область ЗагрузкаXLS
	
&НаКлиенте
Процедура ЗагрузитьExcel(Команда)
	СтандартнаяОбработка = Ложь;
	ДиалогВыбораФайла =	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр		 = "Файл Excel (*.xls)|*.xls*";
	ДиалогВыбораФайла.Расширение	 = "xls";
	ДиалогВыбораФайла.Заголовок		 = "Выберите файл";
	//ДиалогВыбораФайла.ПолноеИмяФайла = ПутьКФайлу;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ПутьКФайлу = ДиалогВыбораФайла.ПолноеИмяФайла;
	КонецЕсли;
	
	Файл = Новый ДвоичныеДанные(ПутьКФайлу);
	Адрес = ПоместитьВоВременноеХранилище(Файл, ЭтаФорма.УникальныйИдентификатор);
	
	ЧислоСтрок = 0;
	ПодключениеКФайлу(Адрес, ЧислоСтрок);
	
	СтрокаДоп = 0;
	
	//чистим шапку
	МассивЛишних = Новый Массив;
	Для каждого ТекСтрока Из ПредварительнаяТЗ Цикл
		Если ТекСтрока["Колонка1"] = "Номер по порядку" Тогда
			СтрокаДоп = СтрокаДоп + 1;
		КонецЕсли;
		МассивЛишних.Добавить(ТекСтрока);
		Если СтрокаДоп Тогда
			СтрокаДоп = СтрокаДоп + 1;
		КонецЕсли;
		Если СтрокаДоп = 3 Тогда
			Прервать;		
		КонецЕсли;
	КонецЦикла; 
	Для каждого ТекСтрока Из МассивЛишних Цикл
		ПредварительнаяТЗ.Удалить(ТекСтрока);
	КонецЦикла;
	
	//чистим подвал
	ТекСтрокаИндекс = 0;
	Для каждого ТекСтрока Из ПредварительнаяТЗ Цикл
		Если Не ЗначениеЗаполнено(ТекСтрока["Колонка1"]) Тогда
			ТекСтрокаИндекс = ПредварительнаяТЗ.Индекс(ТекСтрока);
			Прервать;			
		КонецЕсли;
	КонецЦикла; 
	Если ТекСтрокаИндекс Тогда
		МассивЛишних = Новый Массив;
		Для ТекСтрока = ТекСтрокаИндекс По ПредварительнаяТЗ.Количество() - 1 Цикл
			МассивЛишних.Добавить(ПредварительнаяТЗ[ТекСтрока]);
		КонецЦикла; 
		
		Для каждого ТекСтрока Из МассивЛишних Цикл
			ПредварительнаяТЗ.Удалить(ТекСтрока);
		КонецЦикла;
	КонецЕсли;
	
	ВремяНачала = ТекущаяДата();
	ЧислоСтрок = ПредварительнаяТЗ.Количество();
	ОсталосьВремени = 0;
	СкоростьЗагрузки = 0;
	
	СоотвФИО = СоотвФИО();
	
	Оклад = ПредопределенноеЗначение("Справочник.ВидыНачисленийОплатыТруда.Оклад");
	
	Для сч = 1 По ПредварительнаяТЗ.Количество() Цикл
		
		счСтроки = сч;
		
		Если счСтроки / 100 = Окр(счСтроки / 100, 0) ИЛИ СкоростьЗагрузки < 1 ИЛИ ЧислоСтрок < 100 Тогда
			СкоростьЗагрузки = ?(ТекущаяДата() - ВремяНачала = 0, 0, Окр(счСтроки / (ТекущаяДата() - ВремяНачала), 2));
			ОсталосьВремени = Окр((ТекущаяДата() - ВремяНачала) / счСтроки * (ЧислоСтрок - счСтроки) / 60, 2);
			
			Состояние("Загрузка..." + " Осталось " + Строка(ОсталосьВремени) + " мин." + " Скорость " + Строка(СкоростьЗагрузки) + " стр/сек",
			счСтроки / ЧислоСтрок * 100, "№ дока: " +  СтрЗаменить(СтрЗаменить("", " ", ""), Символы.НПП, "") +
			" (" + Строка(счСтроки) + "/" + Строка(ЧислоСтрок) + ")" );
		КонецЕсли;
		
		счСтроки = счСтроки - 1;
		
		НоваяСтрока = Объект.ТабличнаяЧасть.Добавить();
		НоваяСтрока.Сотрудник = СоотвФИО.Получить(ПредварительнаяТЗ[счСтроки]["Колонка3"]);
		Если Не ЗначениеЗаполнено(НоваяСтрока.Сотрудник) Тогда
			НоваяСтрока.Сотрудник = СоотвФИО.Получить(ПредварительнаяТЗ[счСтроки]["Колонка2"]);
		КонецЕсли;
		НоваяСтрока.ВидНачисления = Оклад;
		НоваяСтрока.Сумма = ПредварительнаяТЗ[счСтроки]["Колонка7"]
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоотвФИО()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	МАКСИМУМ(Сотрудники.Ссылка) КАК Ссылка,
	               |	Сотрудники.Наименование КАК Наименование,
	               |	Сотрудники.Фамилия КАК Фамилия,
	               |	Сотрудники.Имя КАК Имя,
	               |	Сотрудники.Отчество КАК Отчество,
	               |	Сотрудники.ТабельныйНомер КАК ТабельныйНомер
	               |ИЗ
	               |	Справочник.Сотрудники КАК Сотрудники
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Сотрудники.Наименование,
	               |	Сотрудники.Фамилия,
	               |	Сотрудники.Имя,
	               |	Сотрудники.Отчество,
	               |	Сотрудники.ТабельныйНомер";
	
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Соотв = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		Соотв.Вставить(Выборка.Наименование, Выборка.Ссылка);
		Если ЗначениеЗаполнено(Выборка.Фамилия) И ЗначениеЗаполнено(Выборка.Имя) И ЗначениеЗаполнено(Выборка.Отчество) Тогда
			Соотв.Вставить(Выборка.Фамилия + " " + Лев(Выборка.Имя, 1) + "." + Лев(Выборка.Отчество, 1) + ".", Выборка.Ссылка);
		КонецЕсли;
		Если ЗначениеЗаполнено(Выборка.ТабельныйНомер) Тогда
			Соотв.Вставить(Выборка.ТабельныйНомер, Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Соотв;
	
КонецФункции // ()

&НаСервере
Процедура ПодключениеКФайлу(Адрес, КолВоСтрокФайла)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	
	ПутьКФайлуСервер = КаталогВременныхФайлов() + "123.xlsx"; //для примера...
	ДвоичныеДанные.Записать(ПутьКФайлуСервер);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Попытка
		// Выполняется долго на больших файлах.
		ТабличныйДокумент.Прочитать(ПутьКФайлуСервер, СпособЧтенияЗначенийТабличногоДокумента.Значение);    // СпособЧтенияЗначенийТабличногоДокумента - новый параметр платформы 8.3.6. Второе значение "Текст".
			
		СписокЛистов = Новый СписокЗначений;
		
		Для Каждого ОбластьТД ИЗ ТабличныйДокумент.Области Цикл
			СписокЛистов.Добавить(ОбластьТД.Имя);
		КонецЦикла;
		
	Исключение
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Внимание);
		Возврат;
	КонецПопытки;
	
	Данные = ТабличныйДокумент.ПолучитьОбласть(СписокЛистов[0].Значение);
	КолВоСтрокФайла = Данные.ПолучитьРазмерОбластиДанныхПоВертикали();
	КолВоКолонокФайла = Данные.ПолучитьРазмерОбластиДанныхПоГоризонтали();

	
	ПредварительнаяТЗ.Очистить();
	
	Для нСтрокаТФ = 2 ПО КолВоСтрокФайла Цикл
		НоваяСтрокаТФ = ПредварительнаяТЗ.Добавить();
		//НоваяСтрокаТФ[0] = нСтрокаТФ;
		нСтрока = СтрЗаменить(нСтрокаТФ, Символы.НПП, "");
		Для нКолонкаТФ = 1 ПО КолВоКолонокФайла Цикл
			нКолонка = СтрЗаменить(нКолонкаТФ, Символы.НПП, "");
			Область = Данные.ПолучитьОбласть("R"+нСтрока+"C"+нКолонка);
			ТекущаяОбласть = Область.ТекущаяОбласть;
			Попытка
				ЗначениеЯчейки = ТекущаяОбласть.Значение;        // Число, Дата.
			Исключение
				ЗначениеЯчейки = СокрЛП(ТекущаяОбласть.Текст);    // Строка, Булево. (Булево как строка "ИСТИНА"/"ЛОЖЬ")
				Если ЗначениеЗаполнено(ЗначениеЯчейки) Тогда
					ЗначениеЯчейки = ПреобразоватьПростоеЗначениеИзСтрокиВТипизованноеЗначение1С(ЗначениеЯчейки);
					Если ТипЗнч(ЗначениеЯчейки) = Тип("Строка") Тогда
						ЗначениеЯчейки = СокрЛП(ЗначениеЯчейки);
					КонецЕсли;
				Иначе
					//ЗначениеЯчейки = Неопределено;
					//Если Область.Рисунки.Количество() > 0 Тогда    // Изображение.
					//	ЗначениеЯчейки = ПолучитьЗначениеЯчейкиОбластиТабличногоДокументаСКартинками(Область, нСтрока, нКолонка, "УИД");
					//КонецЕсли;
				КонецЕсли;
			КонецПопытки;
			
			ИмяКолонки = "Колонка" + нКолонка;
			НоваяСтрокаТФ[ИмяКолонки] = ЗначениеЯчейки;
			
			// Используется при формировании таблицы на форме обработки.
			//ШиринаКолонки = ПредварительнаяТЗ.Колонки[ИмяКолонки].Ширина;
			//ДлинаСтроки    = СтрДлина(СокрЛП(НоваяСтрокаТФ[ИмяКолонки]));
			//ПредварительнаяТЗ.Колонки[ИмяКолонки].Ширина = ?(ШиринаКолонки < ДлинаСтроки, ДлинаСтроки, ШиринаКолонки);
		КонецЦикла;
	КонецЦикла;		
	//КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти 

#Область ПреобразованиеЗначений
// ПРЕОБРАЗОВАНИЕ СТРОКИ К ТИПИЗОВАННОМУ ЗНАЧЕНИЮ 1С.

&НаСервере
Функция ПреобразоватьПростоеЗначениеИзСтрокиВТипизованноеЗначение1С(Знач ИсходноеЗначение)
	
	Если НЕ ИсходноеЗначение = "" Тогда
		Если ТолькоЦифрыИЗапятаяВСтроке(ИсходноеЗначение, Истина, Ложь) Тогда
			Попытка
				Возврат Число(ИсходноеЗначение);
			Исключение
				Возврат ИсходноеЗначение
			КонецПопытки;
		Иначе
			Если ВРег(ИсходноеЗначение) = "ИСТИНА" ИЛИ ВРег(ИсходноеЗначение) = ("ИСТИНА"+Символы.ПС) ИЛИ ВРег(ИсходноеЗначение) = "TRUE" ИЛИ ВРег(ИсходноеЗначение) = ("TRUE"+Символы.ПС) Тогда
				Возврат Истина;
			ИначеЕсли ВРег(ИсходноеЗначение) = "ЛОЖЬ" ИЛИ  ВРег(ИсходноеЗначение) = ("ЛОЖЬ"+Символы.ПС) ИЛИ ВРег(ИсходноеЗначение) = "FALSE" ИЛИ ВРег(ИсходноеЗначение) = ("FALSE"+Символы.ПС) Тогда
				Возврат Ложь;
			Иначе
				Возврат ПреобразоватьИзСтрокиВДату(ИсходноеЗначение);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИсходноеЗначение
	
КонецФункции

// Проверяет, содержит ли строка только цифры и запятую.
//
// Параметры:
//  СтрокаПроверки          - Строка - Строка для проверки
//  УчитыватьЛидирующиеНули - Булево - Флаг учета лидирующих нулей, если Истина, то ведущие нули пропускаются
//  УчитыватьПробелы        - Булево - Флаг учета пробелов, если Истина, то пробелы при проверке игнорируются
//
// Возвращаемое значение:
//   Булево - Истина - строка содержит только цифры или пустая, Ложь - строка содержит иные символы.
//
&НаСервере
Функция ТолькоЦифрыИЗапятаяВСтроке(Знач СтрокаПроверки, Знач УчитыватьЛидирующиеНули = Истина, Знач УчитыватьПробелы = Истина)
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ УчитыватьПробелы Тогда
		СтрокаПроверки = СтрЗаменить(СтрокаПроверки, " ", "");
		СтрокаПроверки = СтрЗаменить(СтрокаПроверки, Символ(160), "");
	КонецЕсли;
	
	Если Сред(СтрокаПроверки, 1, 1) = "-" Тогда
		СтрокаПроверки = Сред(СтрокаПроверки, 2, СтрДлина(СтрокаПроверки));
	КонецЕсли;
	
	Если ПустаяСтрока(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ УчитыватьЛидирующиеНули Тогда
		Позиция = 1;
		// Взятие символа за границей строки возвращает пустую строку
		Пока Сред(СтрокаПроверки, Позиция, 1) = "0" Цикл
			Позиция = Позиция + 1;
		КонецЦикла;
		СтрокаПроверки = Сред(СтрокаПроверки, Позиция);
	КонецЕсли;
	
	// Если содержит только цифры, то в результате замен должна быть получена пустая строка
	// Проверять при помощи ПустаяСтрока нельзя, так как в исходной строке могут быть пробельные символы
	Возврат СтрДлина(
	СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить(
	СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( 
	СтрокаПроверки, "0", ""), "1", ""), "2", ""), "3", ""), "4", ""), "5", ""), "6", ""), "7", ""), "8", ""), "9", ""), ",", "")
	) = 0;
	
КонецФункции

// Преобразование строки вида "01.01.13" или "01.01.2013" к значению типа "дата".
// Возможны друние форматы даты в файле EXCEL.
&НаСервере
Функция ПреобразоватьИзСтрокиВДату(Знач СтрокаДаты)
	Перем ScrptCtrl, OutDate;
	
	Попытка
		ScrptCtrl = Новый COMОбъект("MSScriptControl.ScriptControl");
		ScrptCtrl.Language="vbscript";
		OutDate = ScrptCtrl.Eval("CDate(""" + СтрокаДаты + """)");
		Возврат OutDate;
	Исключение
		//Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат СтрокаДаты;
	
КонецФункции 

// ПОЛУЧЕНИЕ ЗНАЧЕНИЯ ДЛЯ РЕКВИЗИТА ТИПА "ФАЙЛ КАРТИНКИ".
// ОБЩЕГО НАЗНАЧЕНИЯ.


&НаСервере
Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",")
	Перем МассивСтрок;
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				МассивСтрок.Добавить(СокрЛП(Стр));
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(СокрЛП(Лев(Стр, Поз - 1)));
			Стр = СокрЛ(Сред(Стр, Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				Если (СокрЛП(Стр) <> "") Тогда
					МассивСтрок.Добавить(СокрЛП(Стр));
				КонецЕсли;
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(СокрЛП(Лев(Стр,Поз - 1)));
			Стр = Сред(Стр, Поз + ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
	Возврат МассивСтрок;
	
КонецФункции

	
#КонецОбласти


#Область КомандыИзменения

&НаКлиенте
Процедура ПоказатьИзмененияВерсий(ИмяКоманды)

	СсылкаНаОбъект = ЭтаФорма.ДокументБУ; 
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка",СсылкаНаОбъект);
	СтруктураКоличествВерсий = сабОбщегоНазначенияБУХ.ПолучитьКоличествоВерсий(СсылкаНаОбъект);
	КолВерсий = СтруктураКоличествВерсий.КоличествоИзмененныхВерсий;
	СравниваемыеВерсии = Новый СписокЗначений;  
	Пока КолВерсий > 0 Цикл
		СравниваемыеВерсии.Добавить(СтруктураКоличествВерсий.КоличествоВерсий, СтруктураКоличествВерсий.КоличествоВерсий);
		СтруктураКоличествВерсий.КоличествоВерсий = СтруктураКоличествВерсий.КоличествоВерсий - 1;
		КолВерсий = КолВерсий - 1;
	КонецЦикла;
	ПараметрыОтчета.Вставить("СравниваемыеВерсии",СравниваемыеВерсии); 
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", ПараметрыОтчета);

КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоДокументу(ИмяКоманды)

	ПерезаполнитьДокументНаОснованиинаСервере();

КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьДокументНаОснованиинаСервере()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.ОбработкаЗаполненияСФормы(ЭтаФорма.ДокументБУ, Неопределено, Истина);
	ЗначениеВРеквизитФормы(ТекОбъект, "Объект");
	
	//ОбновленнаяЗапись = РегистрыСведений.сабОбработкаДокументов.СоздатьМенеджерЗаписи();
	//ОбновленнаяЗапись.ДокументБУ = ЭтаФорма.ДокументБУ;
	//ОбновленнаяЗапись.ДокументУУ = Объект.Ссылка;
	//ОбновленнаяЗапись.ДатаОбработки = ТекущаяДата();
	//ОбновленнаяЗапись.Автор = ПараметрыСеанса.ТекущийПользователь;
	//ОбновленнаяЗапись.Модифицирован = Ложь;
	//ОбновленнаяЗапись.Записать();
	Элементы.ЭлементПерезаполнитьПоДокументу.Доступность = Ложь;
	
	ПриСозданииНаСервере(Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОповеститьРегистрОбработанных", Новый Структура("ДокументУУ, ДокументБУ", Объект.Ссылка, ?(БюджетныйНаКлиенте.ЕстьСвойствоОбъекта(ЭтаФорма, "ДокументБУ"), ЭтаФорма.ДокументБУ, Неопределено)));	
КонецПроцедуры
