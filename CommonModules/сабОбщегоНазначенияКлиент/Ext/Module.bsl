﻿
Процедура ПоказатьНесохраненныеДанные() Экспорт
	
	Если сабОбщегоНазначения.ИмеютсяНесохраненныеДанные() Тогда
		ОткрытьФорму("ОбщаяФорма.СохраненныеДанныеФорм");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеЗаписиАвтосохраняемойФормы(Форма) экспорт
	
	Если Форма.РежимВосстановления Тогда
		сабОбщегоНазначения.ОчиститьАвтосохраненияОбъекта(Форма.Объект.Ссылка);
		Оповестить("ОбъектВосстановлен", Форма.Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗапуститьИнформационнуюБазу(ИБ, РежимКонфигуратора = Ложь) Экспорт

	//Сейчас используется СоединенияИБКлиент.ЗапуститьИнформационнуюБазу(ИБ, РежимКонфигуратора = Ложь)
	
КонецПроцедуры

Функция ПроверитьСчет(ТекДанные, ПроверкаСчетаВыполнена = Ложь, ТекДанныеСтруктура = Неопределено) Экспорт
	
	Если ТекДанные = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли ПроверкаСчетаВыполнена Тогда
		ПроверкаСчетаВыполнена = Ложь;
		Возврат Истина;
	ИначеЕсли ТипЗнч(ТекДанные) = Тип("СправочникСсылка.БанковскиеСчета") ИЛИ ТипЗнч(ТекДанные) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
		БанкСчет = ТекДанные;
		
		Если ТипЗнч(ТекДанные) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
			ТекДанныеСтруктура = БюджетныйНаСервере.ВернутьРеквизиты(БанкСчет, "Наименование, саб_Закрыт, Банк, Банк.сабСтатусБанка, Ответственный");
			ТекДанныеСтруктура.Вставить("СтатусСчета", ТекДанныеСтруктура.саб_Закрыт);
			ТекДанныеСтруктура.Вставить("СтатусБанка", ТекДанныеСтруктура.БанксабСтатусБанка);
			ТекДанныеСтруктура.Вставить("Ответственный", ТекДанныеСтруктура.Ответственный);
		Иначе
			ТекДанныеСтруктура = БюджетныйНаСервере.ВернутьРеквизиты(БанкСчет, "Наименование, саб_Закрыт, Банк, Банк.сабСтатусБанка");
			ТекДанныеСтруктура.Вставить("СтатусСчета", ТекДанныеСтруктура.саб_Закрыт);
			ТекДанныеСтруктура.Вставить("СтатусБанка", ТекДанныеСтруктура.БанксабСтатусБанка);
		КонецЕсли;
		
	Иначе
		ТекДанныеСтруктура = ТекДанные;
	КонецЕсли;
	
	Если сабОбщегоНазначения.СчетНеработающий(ТекДанныеСтруктура.СтатусСчета) Тогда
		ТекстВопроса = "Внимание! Банковский счет " + Строка(ТекДанныеСтруктура.Наименование) + " " + Строка(ТекДанныеСтруктура.СтатусСчета) + ". Продолжить?";
		Если Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если сабОбщегоНазначения.БанкНеработающий(ТекДанныеСтруктура.СтатусБанка) Тогда
		ТекстВопроса = "Внимание! Банк " + Строка(ТекДанныеСтруктура.Банк) + " " + Строка(ТекДанныеСтруктура.СтатусБанка) + ". Продолжить?";
		Если Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	//Если сабОбщегоНазначения.БанкНеработающий(ТекДанныеСтруктура.СтатусБанка) Тогда
	//	ТекстВопроса = "Внимание! Банк " + Строка(ТекДанныеСтруктура.Банк) + " " + Строка(ТекДанныеСтруктура.СтатусБанка) + ". Продолжить?";
	//	Если Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
	//		Возврат Ложь;
	//	КонецЕсли;
	//КонецЕсли;
	
	Если ТекДанныеСтруктура.Свойство("Ответственный") И Не ЗначениеЗаполнено(ТекДанныеСтруктура.Ответственный) Тогда
		ТекстВопроса = "Внимание! Банковскому счету " + Строка(ТекДанныеСтруктура.Наименование) + " не назначен ответственный. Продолжить?";
		Если Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	//ДатаЗакрытия  = БюджетныйНаСервере.ВернутьРеквизит(ВыбранныйСчет, "ДатаЗакрытия");
	//Если ЗначениеЗаполнено(ДатаЗакрытия) и ДатаЗакрытия < ТекущаяДата() Тогда
	//	ТекстВопроса = "Выбранный счет был закрыт " + Формат(ДатаЗакрытия, "ДФ=dd.MM.yyyy") + " Все равно продолжить?";
	//	Если Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
	//		Возврат Ложь;
	//	КонецЕсли;
	//КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура УстановитьПодстветкуСчетов(ТекДанныеСтруктураОрганизации = Неопределено, ТекДанныеСтруктураКонтрагента = Неопределено, ТекФорма) Экспорт
		
	Если ЗначениеЗаполнено(ТекФорма.Объект.БанковскийСчет) Тогда
		
		Если ТекДанныеСтруктураОрганизации = Неопределено Тогда
			ТекДанныеСтруктураОрганизации = БюджетныйНаСервере.ВернутьРеквизиты(ТекФорма.Объект.БанковскийСчет, "Наименование, саб_Закрыт, Банк, Банк.сабСтатусБанка");
			ТекДанныеСтруктураОрганизации.Вставить("СтатусСчета", ТекДанныеСтруктураОрганизации.саб_Закрыт);
			ТекДанныеСтруктураОрганизации.Вставить("СтатусБанка", ТекДанныеСтруктураОрганизации.БанксабСтатусБанка);
		КонецЕсли;
		
		Если ТекФорма.Элементы.Найти("СчетОрганизации") = Неопределено Тогда
			ЭлементСчетОрганизации = ТекФорма.Элементы.БанковскийСчет;
		Иначе
			ЭлементСчетОрганизации = ТекФорма.Элементы.СчетОрганизации;
		КонецЕсли;	
		
		ЭлементСчетОрганизации.ЦветФона = Новый Цвет(255, 255, 255);
		
		Если ТекДанныеСтруктураОрганизации.саб_Закрыт = ПредопределенноеЗначение("Перечисление.сабСтатусыБанковскихСчетов.ПодИнкассовым") ИЛИ ТекДанныеСтруктураОрганизации.БанксабСтатусБанка = ПредопределенноеЗначение("Перечисление.сабСтатусыБанков.НаСтадииЗакрытия") ИЛИ 
			ТекДанныеСтруктураОрганизации.саб_Закрыт = ПредопределенноеЗначение("Перечисление.сабСтатусыБанковскихСчетов.ПрочаяБлокировка") ИЛИ ТекДанныеСтруктураОрганизации.БанксабСтатусБанка = ПредопределенноеЗначение("Перечисление.сабСтатусыБанков.ПрочааНеблагонадежность") Тогда
			ЭлементСчетОрганизации.ЦветФона = Новый Цвет(255, 255, 0);
		КонецЕсли;
		
		Если ТекДанныеСтруктураОрганизации.саб_Закрыт = ПредопределенноеЗначение("Перечисление.сабСтатусыБанковскихСчетов.Закрыт") ИЛИ ТекДанныеСтруктураОрганизации.БанксабСтатусБанка = ПредопределенноеЗначение("Перечисление.сабСтатусыБанков.Закрыт") Тогда
			ЭлементСчетОрганизации.ЦветФона = Новый Цвет(255, 102, 0);
		КонецЕсли;
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ТекФорма.Объект.СчетКонтрагента) Тогда
		
		Если ТекДанныеСтруктураКонтрагента = Неопределено Тогда
			ТекДанныеСтруктураКонтрагента = БюджетныйНаСервере.ВернутьРеквизиты(ТекФорма.Объект.СчетКонтрагента, "Наименование, саб_Закрыт, Банк, Банк.сабСтатусБанка");
			ТекДанныеСтруктураКонтрагента.Вставить("СтатусСчета", ТекДанныеСтруктураКонтрагента.саб_Закрыт);
			ТекДанныеСтруктураКонтрагента.Вставить("СтатусБанка", ТекДанныеСтруктураКонтрагента.БанксабСтатусБанка);
		КонецЕсли;
		
		ТекФорма.Элементы.СчетКонтрагента.ЦветФона = Новый Цвет(255, 255, 255);	
		
		Если ТекДанныеСтруктураКонтрагента.саб_Закрыт = ПредопределенноеЗначение("Перечисление.сабСтатусыБанковскихСчетов.ПодИнкассовым") ИЛИ ТекДанныеСтруктураКонтрагента.БанксабСтатусБанка = ПредопределенноеЗначение("Перечисление.сабСтатусыБанков.НаСтадииЗакрытия") ИЛИ 
			ТекДанныеСтруктураКонтрагента.саб_Закрыт = ПредопределенноеЗначение("Перечисление.сабСтатусыБанковскихСчетов.ПрочаяБлокировка") ИЛИ ТекДанныеСтруктураКонтрагента.БанксабСтатусБанка = ПредопределенноеЗначение("Перечисление.сабСтатусыБанков.ПрочааНеблагонадежность") Тогда
			ТекФорма.Элементы.СчетКонтрагента.ЦветФона = Новый Цвет(255, 255, 0);
		КонецЕсли;
		
		Если ТекДанныеСтруктураКонтрагента.саб_Закрыт = ПредопределенноеЗначение("Перечисление.сабСтатусыБанковскихСчетов.Закрыт") ИЛИ ТекДанныеСтруктураКонтрагента.БанксабСтатусБанка = ПредопределенноеЗначение("Перечисление.сабСтатусыБанков.Закрыт") Тогда
			ТекФорма.Элементы.СчетКонтрагента.ЦветФона = Новый Цвет(255, 102, 0);
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры
 
#Область сабРаботаСФайлами

Процедура КУ_ОткрытьФайл(Ссылка) Экспорт
	
	КаталогПользователя = БюджетныйНаСервере.ВернутьРеквизит(БюджетныйНаСервере.ПолучитьПользователя(), "КаталогПользователя");
	НаименованиеФайла   = БюджетныйНаСервере.ВернутьРеквизит(Ссылка, "Наименование");
	ТекПолноеНаим = КаталогПользователя + "\" + Строка(НаименованиеФайла);
	ВыбКат = Новый Файл(КаталогПользователя);
	Если ПустаяСтрока(КаталогПользователя) ИЛИ НЕ ВыбКат.Существует() Тогда
		Если Вопрос("Временный каталог пользователя " + Строка(БюджетныйНаСервере.ПолучитьПользователя()) + " не назначен или не найден. Желаете установить каталог пользователя сейчас?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			ТекКаталог = ОткрытьФормуМодально("Справочник.Пользователи.Форма.ФормаВыбораКаталога", Новый Структура("Ключ", БюджетныйНаСервере.ПолучитьПользователя()) );
			Если ТекКаталог = Неопределено Тогда
				Возврат;
			КонецЕсли;
		Иначе
			Предупреждение("Временный каталог пользователя " + Строка(БюджетныйНаСервере.ПолучитьПользователя()) + " не назначен. Открытие прикрепленных файлов невозможно.");
			Возврат;
		КонецЕсли;
	КонецЕсли;
			
	Если НЕ ПустаяСтрока(ТекПолноеНаим) Тогда
		Попытка
			АдресХранилища = РаботаСФайламиСлужебныйВызовСервера.ВХранилище(Ссылка);
		Исключение
			АдресХранилища = РаботаСФайламиСлужебныйВызовСервера.ВХранилищеСтарое(Ссылка);
		КонецПопытки;
		Если АдресХранилища = Неопределено Тогда
			Предупреждение("Данный файл был очищен в связи с пометкой на удаление");
			Возврат;
		КонецЕсли;	
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
		ВыбФайл = Новый Файл(ТекПолноеНаим);
		ДвоичныеДанные.Записать(ТекПолноеНаим);
		Пока  НЕ ВыбФайл.Существует() Цикл
			ОбработкаПрерыванияПользователя();
		КонецЦикла;
		ЗапуститьПриложение(ТекПолноеНаим);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СохранитьФайлВБазе(ПараметрыВыбора, ПутьКФайлу, Владелец = Неопределено, ОткрыватьЗаписанныйФайл = Истина) Экспорт
	
	ВыбФайл = Новый Файл(ПутьКФайлу);
	Если ВыбФайл.Существует() Тогда
		Размер = ВыбФайл.Размер();
		
		Если ПараметрыВыбора.Ссылка Тогда
			СсылкаФайл = ПутьКФайлу;
			ОграничениеРазмера = 10;
		Иначе
			СсылкаФайл = "";
			ОграничениеРазмера = 3;
		КонецЕсли;
						
		Если ПараметрыВыбора.ВидФайла = "Картинка" ИЛИ ПараметрыВыбора.ВидФайла = "Оттиск" Тогда
			МойФайл = Новый Картинка(ПутьКФайлу);
		Иначе
			МойФайл = Новый ДвоичныеДанные(ПутьКФайлу);
		КонецЕсли;
		
		Если РаботаСФайламиСлужебныйВызовСервера.ПроверитьДубли(ВыбФайл.Имя) Тогда
			СуществующийСправочник = БюджетныйНаСервере.СправочникНайтиПоНаименованию("Файлы", ВыбФайл.Имя, Истина);
			ВладелецСуществующегоФайла = РаботаСФайламиСлужебныйВызовСервера.НайтиВладельцаПрикрепленногоФайла(СуществующийСправочник);
			Если (ВладелецСуществующегоФайла = Неопределено Или РаботаСФайламиСлужебныйВызовСервера.ПроверитьВладельцаПрикрепленногоОбъекта(ВладелецСуществующегоФайла)) И (БюджетныйНаСервере.ВернутьРеквизит(СуществующийСправочник, "Автор") = БюджетныйНаСервере.ПолучитьПользователя()) Тогда
				ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Файл %1 существует, но нигде не используется. Хотите его заменить?", ВыбФайл.Имя);
				Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
				Если Ответ = КодВозвратаДиалога.Да Тогда
					НовыйФайл = СуществующийСправочник; 	
				Иначе
					ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Файл именем %1 уже существует! Измените имя и загрузите заново!", ВыбФайл.Имя);
					Предупреждение(ТекстПредупреждения);
					Возврат Неопределено;			
				КонецЕсли;	
			Иначе	
				ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Файл именем %1 уже существует! Измените имя и загрузите заново!", ВыбФайл.Имя);
				Предупреждение(ТекстПредупреждения);
				Возврат Неопределено;			
			КонецЕсли;
		Иначе
			НовыйФайл = РаботаСФайламиСлужебныйВызовСервера.СоздатьФайлВБД(ВыбФайл.Имя, СсылкаФайл, Размер, ПараметрыВыбора.ВидФайла, Владелец, ПараметрыВыбора);
		КонецЕсли;
		
		АдресХранилища = ПоместитьВоВременноеХранилище(МойФайл);
		
		РаботаСФайламиСлужебныйВызовСервера.КопироватьФайлНаСервере(НовыйФайл, АдресХранилища);
		
		//ОповеститьОбИзменении(НовыйФайл);
		
		Если ОткрыватьЗаписанныйФайл Тогда
			ОткрытьЗначение(НовыйФайл);
		КонецЕсли;
		
		Оповестить("НовыйФайл", НовыйФайл);
		Возврат НовыйФайл;
	Иначе
		Предупреждение("Файл не найден!");
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции	

#КонецОбласти

Процедура СтандартныеОтчеты_ОтборыПравоеЗначениеНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт

	Если Строка(Форма.Элементы.Отборы.ТекущиеДанные.ЛевоеЗначение) = "Субконто2" Тогда
		Для каждого ТекСтрокаОтбора Из Форма.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
			Если Строка(ТекСтрокаОтбора.ЛевоеЗначение) = "Субконто1" Тогда
				ВладелецСсылка = ТекСтрокаОтбора.ПравоеЗначение;
				
				Если ТипЗнч(ВладелецСсылка) = Тип("СправочникСсылка.Предприятия") Тогда
					СтандартнаяОбработка = Ложь;
					ФормаВыбора = ПолучитьФорму("Справочник.ВнутренниеДоговоры.Форма.ФормаВыбораПоВладельцу", ,Элемент);
					ЭлементОтбора = ФормаВыбора.Список.Отбор.Элементы[0];
					ЭлементОтбора.ПравоеЗначение = ВладелецСсылка;
					ФормаВыбора.Открыть();
				КонецЕсли;
				
				Если ТипЗнч(ВладелецСсылка) = Тип("СправочникСсылка.Контрагенты") Тогда
					//Если Форма.Отчет.Счет = ПредопределенноеЗначение("ПланСчетов.Учетный._60_07") Тогда
					//	Продолжить;
					//КонецЕсли;	
					СтандартнаяОбработка = Ложь;
					ФормаВыбора = ПолучитьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаВыбораПоВладельцу", ,Элемент);
					ИдентификаторПользовательскойНастройки = ФормаВыбора.Список.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки;
					ПользовательскийОтбор = ФормаВыбора.Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдентификаторПользовательскойНастройки);
					ЭлементОтбора = ПользовательскийОтбор.Элементы[0];
					ЭлементОтбора.ПравоеЗначение = ВладелецСсылка;
					ЭлементОтбора.Использование = Истина;
					ФормаВыбора.Открыть();
				КонецЕсли;
				
			КонецЕсли;
			//Прервать;
		КонецЦикла; 
		
	КонецЕсли;
КонецПроцедуры

#Область РаботаСРасшифровкойДДС
Процедура сабРасшифроватьСуммуДДС(ЭтаФорма, Отчет, СтруктураПараметровРасшифровки) Экспорт

	ФормаПечати = ПолучитьФорму("Отчет.УниверсальнаяРасшифровка.Форма",, ЭтаФорма, Истина);
	НастройкиОтчета = ФормаПечати.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
	
	Если Не ЗначениеЗаполнено(СтруктураПараметровРасшифровки.Период) Тогда
		СтруктураПараметровРасшифровки.Период = СтандартныеОтчетыКлиентСервер.ПолучитьПараметр(Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ВыбПериод").Значение;
	КонецЕсли;
	
	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиОтчета, "Период", СтруктураПараметровРасшифровки.Период);
	//СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиОтчета, "Статья", СтруктураПараметровРасшифровки.Статья);
	//СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиОтчета, "Предприятие", СтруктураПараметровРасшифровки.Предприятие);
	//СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиОтчета, "Подразделение", СтруктураПараметровРасшифровки.Подразделение);
	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиОтчета, "Сценарий", СтруктураПараметровРасшифровки.Сценарий);
	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиОтчета, "ЭквивалентнаяВалюта", СтруктураПараметровРасшифровки.ЭквивалентнаяВалюта);
	СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиОтчета, "ЭтоРасшифровкаФакта", СтруктураПараметровРасшифровки.ЭтоРасшифровкаФакта);
	
	// очищаем отбор в расшифровке
	Для Каждого ТекЭлементПН Из НастройкиОтчета.Элементы Цикл
		
		Если ТипЗнч(ТекЭлементПН) = Тип("ОтборКомпоновкиДанных") Тогда
			ТекЭлементПН.Элементы.Очистить();
		КонецЕсли;
		
	КонецЦикла;
	
	// заполняем отборы
	Если НЕ СтруктураПараметровРасшифровки.Предприятие = Неопределено Тогда
		СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(ФормаПечати.Отчет.КомпоновщикНастроек, 
		"Предприятие", 
		СтруктураПараметровРасшифровки.Предприятие, 
		?(ЗначениеЗаполнено(СтруктураПараметровРасшифровки.Предприятие), ВидСравненияКомпоновкиДанных.ВИерархии, ВидСравненияКомпоновкиДанных.Равно), 
		Истина, 
		Истина, 
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	КонецЕсли;
	
	Если НЕ СтруктураПараметровРасшифровки.Подразделение = Неопределено Тогда
				
		Если Не ЗначениеЗаполнено(СтруктураПараметровРасшифровки.Подразделение) Тогда
			СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(ФормаПечати.Отчет.КомпоновщикНастроек, 
			"Подразделение", 
			, 
			ВидСравненияКомпоновкиДанных.НеЗаполнено, 
			Истина, 
			Истина, 
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);	
		Иначе
			СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(ФормаПечати.Отчет.КомпоновщикНастроек, 
			"Подразделение", 
			СтруктураПараметровРасшифровки.Подразделение, 
			?(ЗначениеЗаполнено(СтруктураПараметровРасшифровки.Подразделение), ВидСравненияКомпоновкиДанных.ВИерархии, ВидСравненияКомпоновкиДанных.Равно), 
			Истина, 
			Истина, 
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ СтруктураПараметровРасшифровки.ВидДвижений = Неопределено Тогда
		СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(ФормаПечати.Отчет.КомпоновщикНастроек, "ВидДвижений", 
		СтруктураПараметровРасшифровки.ВидДвижений, ВидСравненияКомпоновкиДанных.Равно, Истина, 
		Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	КонецЕсли;
	
	Если НЕ СтруктураПараметровРасшифровки.Статья = Неопределено Тогда
		СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(ФормаПечати.Отчет.КомпоновщикНастроек, "Статья", 
		СтруктураПараметровРасшифровки.Статья, ?(ЗначениеЗаполнено(СтруктураПараметровРасшифровки.Статья), ВидСравненияКомпоновкиДанных.ВИерархии, ВидСравненияКомпоновкиДанных.Равно), Истина, 
		Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	КонецЕсли;
	
	// расшифровка по кор субконто1 {
	Если НЕ СтруктураПараметровРасшифровки.КорСубконто1 = Неопределено Тогда
		СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(ФормаПечати.Отчет.КомпоновщикНастроек, "КорСубконто1", 
		СтруктураПараметровРасшифровки.КорСубконто1, ВидСравненияКомпоновкиДанных.Равно, Истина, 
		Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	КонецЕсли;
	//}
	
	Для Каждого ТекЭлементОтбора Из СтруктураПараметровРасшифровки.МассивОтборов Цикл
		СтандартныеОтчетыКлиентСервер.ДобавитьОтбор(ФормаПечати.Отчет.КомпоновщикНастроек, ТекЭлементОтбора.ЛевоеЗначение, 
		ТекЭлементОтбора.ПравоеЗначение, ТекЭлементОтбора.ВидСравнения, ТекЭлементОтбора.Использование, 
		Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	КонецЦикла;
	
	ОтборЗаголовок = "";
	
	Для Каждого ТекЭлементНастроекКД Из ФормаПечати.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		
		Если ТипЗнч(ТекЭлементНастроекКД) = Тип("ОтборКомпоновкиДанных") Тогда
			ОтборЗаголовок = Строка(ТекЭлементНастроекКД)
		КонецЕсли;
		
	КонецЦикла;
	
	// а план или факт и замену регистра, сделаем при компоновке результата
	ФормаПечати.СкомпоноватьРезультат();
	
	Если ЗначениеЗаполнено(ОтборЗаголовок) Тогда
		ФормаПечати.АвтоЗаголовок = Ложь;
		ФормаПечати.Заголовок = "Расшифровка: " + ОтборЗаголовок;
	КонецЕсли;
	
	ФормаПечати.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
	ФормаПечати.Открыть();

КонецПроцедуры

	
#КонецОбласти

Процедура УстановитьСвойствоЭлемента(Элементы, ИмяЭлемента, ИмяСвойства, Значение) Экспорт
	
	Если Не Элементы.Найти(ИмяЭлемента) = Неопределено Тогда
		Элементы[ИмяЭлемента][ИмяСвойства] = Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоПрикрепленныхФайлов(Форма, Реквизит = Неопределено, КороткоеПредставление = Ложь) экспорт
	
	ТекСсылка = ?(ТипЗнч(Форма) = Тип("УправляемаяФорма"), Форма.Объект.Ссылка, Форма);
	
	Если ТипЗнч(ТекСсылка) = Тип("СправочникСсылка.Задача") тогда
		ТекЗаявка = ?(ТипЗнч(Форма) = Тип("УправляемаяФорма"), Форма.Объект.Заявка, БюджетныйНаСервере.ВернутьРеквизит(Форма, "Заявка"));
		КоличествоФайлов = сабОбщегоНазначения.КоличествоПрикрепленныхФайлов(ТекЗаявка);
		Если КоличествоФайлов = 0 Тогда
			Если Реквизит = Неопределено Тогда
				Форма.Элементы.ОткрытьФайл.Видимость = Ложь;
			КонецЕсли;
			Реквизит = "";
		Иначе
			Если Реквизит = Неопределено Тогда
				Форма.Элементы.ОткрытьФайл.Видимость = Истина;
				Форма.Элементы.ОткрытьФайл.Заголовок = "Прикрепленные файлы (" + КоличествоФайлов + ")";
			КонецЕсли;
			Реквизит = ?(КороткоеПредставление, Строка(КоличествоФайлов), "Прикрепленные файлы (" + КоличествоФайлов + ")");
		КонецЕсли;
	иначе
		КоличествоФайлов = сабОбщегоНазначения.КоличествоПрикрепленныхФайлов(ТекСсылка);
		Если КоличествоФайлов = 0 Тогда
			Если НЕ Форма.Элементы.Найти("СправочникФайлыПрикрепленныеФайлы") = Неопределено Тогда
				Форма.Элементы.СправочникФайлыПрикрепленныеФайлы.Заголовок = "Прикрепленные файлы";
			КонецЕсли;
		Иначе
			Если НЕ Форма.Элементы.Найти("СправочникФайлыПрикрепленныеФайлы") = Неопределено Тогда
				Форма.Элементы.СправочникФайлыПрикрепленныеФайлы.Заголовок = "Прикрепленные файлы (" + КоличествоФайлов + ")";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

